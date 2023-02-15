# Sophie Fromm 02 2023
rm(list = ls())
# load packages

library("ggplot2")
library('emmeans')
library("RColorBrewer")
library(gridExtra)
library(psych)
library(readxl)
library(PerformanceAnalytics)
library(statmod)
library(lme4)
library(ggcorrplot)
library(plotly)
library("treemap")
library("sjPlot")
library(buildmer)
library(readr)
library(mgcv)
library(grid)
library(ggplotify)

data<-read_excel("HeRoine_data/HeRoine_data_Rexport.xlsx")
sums<-read_excel("HeRoine_data/HeRoine_selfrep_sums_Rexport.xlsx")
master<-read_excel("HeRoine_data/HeRoine_master_Rexport.xlsx")

################ RAW DATA ANALYSIS OF OBSERVED BEHAVIOR ########################

# Compute absolute Prediction Errors (PEs) ==========
#Absolute magnitude of average prediction error (subjective PE) and performance error (objective PE), and update
data$PE_sub_abs<-abs(data$PE); data$PE_objective_abs<-abs(data$PE_objective)
data$UP_sub_abs<-abs(data$up_bucket)

# Compute Learning Rate =========
#compute LR
data$LR_dat <- data$UP_sub/data$PE_sub

# set large LRs to 1, neagtive to 0 and first trial of each run to NA (bc, runs were not consecutive)
data$LR_dat[data$LR_dat>1] = 1; data$LR_dat[data$LR_dat<0] = 0
data$LR_dat[data$master_trial_all==70] = NA # last trial of each run, LR = NA, because runs were not consecutive
data$LR_dat[data$master_trial_all==140] = NA; data$LR_dat[data$master_trial_all==210] = NA; data$LR_dat[data$master_trial_all==280] = NA ;

# PE mean and sd per noise condition
data_by_noise<- data %>% group_by(noise)
summary(data_by_noise$PE_objective_abs)

## Descriptive stats PER SUBJECT across all runs
subject_PE_allruns <- data %>%group_by(RedcapID) %>%  summarise_at(c("PE_sub_abs","PE_objective_abs", "UP_sub_abs"), funs(lst(mean(., na.rm=TRUE))))
#convert to numeric
subject_PE_allruns$PE_objective_abs <- as.numeric(subject_PE_allruns$PE_objective_abs); subject_PE_allruns$PE_sub_abs <- as.numeric(subject_PE_allruns$PE_sub_abs); subject_PE_allruns$UP_sub_abs<- as.numeric(subject_PE_allruns$UP_sub_abs)
# PER SUBJECT by noise condition
subject_PE_byNoise <- data %>%group_by(RedcapID, noise) %>%  summarise_at(c("PE_sub_abs","PE_objective_abs", "UP_sub_abs"), funs(lst(mean(., na.rm=TRUE))))

# Merge behavioral stats with selfreport
sums_all <- base::merge(sums, subject_PE_allruns, by.x=c("selfrep.id_nr"),
                        by.y=c("RedcapID"))#,all=TRUE)

# ... and the stats by noise condition
sums_bynoise <- base::merge(sums, subject_PE_byNoise, by.x=c("selfrep.id_nr"),
                            by.y=c("RedcapID"))#,all=TRUE)

# Exclude CP trial and later than 17 trials after CP
data$blocktrial<-data$master_blocktrial
data_short<-subset(data, blocktrial!=1); data_short<-subset(data_short, blocktrial<19)

#group by PLE-quartile
quantile(data$PLE)
data_PLE <- data %>% mutate(PLE_group = case_when(PLE<=-.6902764~ "Low PLE", PLE>=.5294493 ~ "High PLE"))
data_PLE$PLE_group[is.na(data_PLE$PLE_group)]  <- "Medium PLE"

############ Regression model selection for PE ##############
data_short$PLE_cent<-scale(data_short$PLE, center = TRUE, scale = FALSE)
# Best model only noise
PEmodel_noise <- buildmer(PE_objective_abs ~ (blocktrial*noise)+(1+blocktrial*noise|RedcapID), data=data_short)
summary(PEmodel_noise)

################  Raw behavior in relation to psychotic-like experiences ################

## Performance Error
PEmodel_PLE <- buildmer(PE_objective_abs ~ (blocktrial*noise*PLE)+(1+blocktrial*noise|RedcapID), data=data_short)
summary(PEmodel_PLE)


# Compute precision

# Functions to compute precision (inspired by Nassar 2021) =========
# Lagged weights // Inputs: "data" of single run of single participant
compute_laggedWeights <- function (x) {
  LR <- x$LR
  
  LR[is.na(LR)] = 0 # replace last trial of run with 0, otherwise code does not work
  LR[LR > 1] <-1 # set LR > 1 to 1, (prevents negative lagged weights)
  
  laggedWeight <-matrix(nrow = 70, ncol = 70) # create empty 70x70 matrix (1 line for each run)
  laggedWeight[1, 1] <- c(LR[1]) # 1st laggedWeight = 1st LR
  
  for (trial in 2:70) { # for each trial
    laggedWeight[trial, 1:trial] <- c(numeric(trial - 1), LR[trial]) # fill row of current trial with 0s and in the diagonal add LR of current trial 
    laggedWeight[trial, 1:trial - 1] <- laggedWeight[trial - 1, 1:trial - 1] * (1 - LR[trial]) # overwrite 0s with content of previous line multiplied with 1-LR of current trial
    #weight of previous samples are now a scaled fraction of corresponding "historical" LRs
  }
  return(laggedWeight)
}

# Precision // Inputs: LaggedWeight of a single run of a single participant from Func 1
compute_precision <- function (x) {
  relStd <- numeric(70);  relPrec <- numeric(70) # create empty df
  #lagged weights = 0 should be NaN, otherwise it a NA trial counts in precision
  laggedWeight_nozeros <- x #
  laggedWeight_nozeros[x == 0] <- NaN
  
  # Squared sum of each row
  for (trial in 1:70) {
    relStd[trial] <- sqrt(sum((laggedWeight_nozeros[trial,])^ 2, na.rm = TRUE))# Formel 3; ?? *noise ?? multiply each by var (if ln = 3.33, if hn = 8.33)
    #square root because of nassars script
    relPrec[trial] <- 1 / (relStd[trial] ^ 2) # tau Formel 2
  }
  
  relPrec <- data.frame(relPrec)
  return(relPrec)
}

# Apply precision functions to data =========

# compute lagged weights for each subject and each run
lW_allruns <- list(); lW_r <- list(); allIDs <- unique(data$RedcapID); colnames(data)[57]<-c("LR")
for (run_i in 1:4) {
  for (sub in 1:300) {
    res <- compute_laggedWeights(filter(data, r == run_i & RedcapID == allIDs[sub]))
    lW_r[sub] <- list(res)
    rm(res)
  }
  lW_allruns[run_i] <- list(lW_r);   lW_r <- list()
}
names(lW_allruns) <- c("run1_ln", "run2_hn", "run3_ln", "run4_hn")

# compute precision for each subject and each run
prec <- list(); prec_allRuns <- list(); mean_prec <- data.frame(); p <- data.frame();  effective_samples <-list()
for (run_i in 1:4) {
  
  for (sub in 1:300) {
    p <- compute_precision(lW_allruns[[run_i]][[sub]])
    prec[sub] <- list(p)
    #effective_samples[sub] <- list(p/(1/280)) What is effective samples?
    rm(p)
  }
  prec_allRuns[run_i] <- list(prec)
}

# Pull out descriptive data =========
mean_prec <- data.frame();
allprec <- data.frame(matrix(nrow = 280, ncol = 0))
d <- matrix(nrow = 70, ncol = 4)

for (sub in 1:300) {
  for (run_i in 1:4) {
    d[, run_i] <- unlist(prec_allRuns[[run_i]][[sub]])
    d[is.infinite(d)] = NaN  #set infinity observations to nan
  }
  allprec[, sub] <- data.frame(c(d))
}

colnames(allprec)<-allIDs
allprec$average_prec<-rowMeans(allprec,na.rm=TRUE)
allprec$blocktrial<-master$blocktrial[1:280]
allprec$block<-master$block
allprec$trial_all<-master$trial_all[1:280]

allprec$noise<-as.factor(c(rep('low noise', 70), rep('high noise', 70), rep('low noise', 70), rep('high noise', 70))) # make categorical  noise factor

#make long format
long_allprec <- allprec %>%
  pivot_longer(`7620424`:`9936518017`, names_to = "ID_prec", values_to = "precision")
long_allprec<-merge(sums, long_allprec,by.x="selfrep.id_nr", by.y="ID_prec")

#exclude first block
long_allprec_short<-subset(long_allprec, block !=1)

#exclude blocktrials >18, because to few blocks to draw conclusions on pop level (<5 blocks)
long_allprec_short<-subset(long_allprec_short, blocktrial<19)

#group by PLE for plotting
long_allprec_PLE <- long_allprec_short %>% mutate(PLE_group = case_when(PLE<=-.6901455~ "Low PLE", PLE>=.5294493 ~ "High PLE"))
long_allprec_PLE$PLE_group[is.na(long_allprec_PLE$PLE_group)]  <- "Medium PLE"

# Best model with PLE
precmodel_PLE <- buildmer(precision ~ (blocktrial*noise*PLE)+(1+blocktrial|selfrep.id_nr), data=long_allprec_short)
summary(precmodel_PLE)

#Relationship of PLE with LR when PE is larger versus small
# pick out all trials with PE < 5 and compute mean LR for each subject
smallPE <- data[data$PE_sub_abs<=5,] %>%group_by(RedcapID) %>%  summarise_at(c("LR"), funs(lst(mean(., na.rm=TRUE))))
# pick out all trials with PE > 50 and compute mean LR for each subject
largePE <- data[data$PE_sub_abs>=50,] %>%group_by(RedcapID) %>%  summarise_at(c("LR"), funs(lst(mean(., na.rm=TRUE))))
smallPE<-na.omit(smallPE); largePE<-na.omit(largePE) 
#convert to numeric
sums_all$LR_smallPE<- as.numeric(smallPE$LR); sums_all$LR_largePE<- as.numeric(largePE$LR); 

#regression on aggregated data with PLE
summary(lm(LR_smallPE~PLE, sums_all))
summary(lm(LR_largePE~PLE, sums_all))