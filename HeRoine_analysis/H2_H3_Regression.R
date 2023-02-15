# Sophie Fromm 02 2023
# H2 Association between PLE and Bayesian belief updating  ----------

################ Regression of PE, CPP, RU on Update ################
# Functions for regression =========
# Inputs: x = data (missings are excluded); y = ids
regress_by_sub_errBased <- function (x, y) {
  
  #Mean center variables
  x$mc_pCha <- scale(x$errBased_pCha, center = TRUE, scale = FALSE)
  x$mc_RU <-  scale(x$errBased_RU, center = TRUE, scale = FALSE) # RU = totSig
  x$mc_PE_sub <-  scale(x$PE_sub, center = TRUE, scale = FALSE)
  x$mc_UP_sub <- scale(x$UP_sub, center = TRUE, scale = FALSE)
  
  # for each of the 300 subjects run individual lm across all runs
  for (i in 1:300) {
    lm_dat  <- subset(x, RedcapID == y[i]) # pull out "data" of single subject
    mod1[[i]] <-lm(mc_UP_sub ~ mc_PE_sub + mc_PE_sub:mc_pCha + mc_PE_sub:mc_RU, # compute linear model
                   data = lm_dat,na.action = na.exclude)
    
    # safe summary in df
    summaryMod1_persubject[[i]] <- summary(mod1[[i]])
    # safe respective subject ID
    mod1_ids[i, 1] <- lm_dat$RedcapID[1]
  }
  return(mod1)
}


#Inputs: x = mod1 from prev function; y = ids
read_coefs_errBased <- function (x, y) {
  coefficients <- data.frame(matrix(nrow = 300))
  for (i in 1:300) {
    coefficients$mod1_ids[i] <- y[i]
    coefficients$bePE[i] <- x[[i]][["coefficients"]][["mc_PE_sub"]]
    coefficients$bePE_pCha[i] <-x[[i]][["coefficients"]][["mc_PE_sub:mc_pCha"]]
    coefficients$bePE_RU[i] <-x[[i]][["coefficients"]][["mc_PE_sub:mc_RU"]]
    
    
    coefficients$pPE[i] <- summary(x[[i]])$coefficients[2, 4]
    coefficients$pPE_pCha[i] <- summary(x[[i]])$coefficients[3, 4]
    coefficients$pPE_RU[i] <- summary(x[[i]])$coefficients[4, 4]
    coefficients$rsquared[i] <- summary(x[[i]])$r.squared
    #coefficients$vif[i] <- vif(x[[i]])
  }
  return(coefficients)
}


# Apply functions to data =========

# Run regression
mod1<-list(); mod1_ids<-data.frame(); summaryMod1_persubject<-list()
allIDs <- unique(data$RedcapID)
mod1<-regress_by_sub_errBased(data, allIDs)

#Read out coefficients to check test against 0
PE_coef<-list(); PE_pCha_coef<-list(); PE_pCha_sigmaU_coef<-list()
coefficients<-read_coefs_errBased(mod1, allIDs)
t.test(coefficients$bePE); t.test(coefficients$bePE_pCha); t.test(coefficients$bePE_RU)

# Check goodness of model
mean(coefficients$rsquared); sd(coefficients$rsquared)
hist(coefficients$rsquared, 50)

# Check relationship with PLE ==========
# merge coefficients with self-report data frame 
coefficients <- base::merge(coefficients, sums, by.x=c("mod1_ids"),
                            by.y=c("selfrep.id_nr"), all.x = TRUE, all.y = TRUE)


model_reg_PLE <- lm(PLE~bePE+bePE_pCha+bePE_RU, coefficients)
model_reg_PLE_r2<-cor.test(coefficients$rsquared,coefficients$PLE)


################ Exploratory analysis of psychiatric self-report measures ################

#z-score sefreports to allow comparisons of magnitude
coefficients$zIUS<-scale(coefficients$selfrep.ius, center = TRUE, scale = TRUE)
coefficients$zAUDIT<-scale(coefficients$selfrep.audit, center = TRUE, scale = TRUE)
coefficients$zOCIR<-scale(coefficients$selfrep.ocir, center = TRUE, scale = TRUE)
coefficients$zAES<-scale(coefficients$selfrep.aes, center = TRUE, scale = TRUE)
coefficients$zSTAIT<-scale(coefficients$selfrep.stait, center = TRUE, scale = TRUE)

# Regressions
model_reg_oci<-model_reg_oci<-lm(zOCIR~bePE+bePE_pCha+bePE_RU, coefficients)
summary(model_reg_oci)

model_reg_stai<-lm(zSTAIT~bePE+bePE_pCha+bePE_RU, coefficients)
summary(model_reg_stai)

model_reg_aes<-lm(zAES~bePE+bePE_pCha+bePE_RU, coefficients)
summary(model_reg_aes)

model_reg_audit<-lm(zAUDIT~bePE+bePE_pCha+bePE_RU, coefficients)
summary(model_reg_audit)

model_reg_ius<-lm(zIUS~bePE+bePE_pCha+bePE_RU, coefficients)
summary(model_reg_ius)

model_reg_pdi<-lm(zPDI~bePE+bePE_pCha+bePE_RU, coefficients)
summary(model_reg_pdi)

model_reg_asi<-lm(zASI~bePE+bePE_pCha+bePE_RU, coefficients)
summary(model_reg_asi)

model_reg_caps<-lm(zCAPS~bePE+bePE_pCha+bePE_RU, coefficients)
summary(model_reg_caps)

#put coefficients and p-values in table
beta_mat_selfrep<-rbind(model_reg_pdi$coefficients, model_reg_asi$coefficients, model_reg_caps$coefficients, model_reg_oci$coefficients,model_reg_stai$coefficients,model_reg_aes$coefficients, model_reg_audit$coefficients)
p_mat_selfrep<-rbind(summary(model_reg_pdi)$coefficients[,4], summary(model_reg_asi)$coefficients[,4], summary(model_reg_caps)$coefficients[,4], summary(model_reg_oci)$coefficients[,4], summary(model_reg_stai)$coefficients[,4],  summary(model_reg_aes)$coefficients[,4],summary(model_reg_audit)$coefficients[,4])

#Exclude Intercept
beta_mat_selfrep<-beta_mat_selfrep[,2:4]
p_mat_selfrep<-p_mat_selfrep[,2:4]

#Naming
rownames(beta_mat_selfrep)<- c("PDI", "ASI", "CAPS", "OCI-R","STAI-T", "AES", "AUDIT")
colnames(beta_mat_selfrep)<-c('PE','CPP','RU')

# multiple comp. correction for pmat
p.adjust(p_mat_selfrep[,1], method = "BH"); p.adjust(p_mat_selfrep[,2], method = "BH"); p.adjust(p_mat_selfrep[,3], method = "BH")


