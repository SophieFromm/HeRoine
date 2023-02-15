# Sophie Fromm 02 2023
# Plots
# high low noise colors
noise_coul<- c("#6699cc", "#225c80")
PLE_coul<- c("#FDDA0D",'#E2891F', "#9B0404")

# Plot trial trajectory
unique_names <- unique(colnames(errBased)); errBased<-errBased[unique_names]
data_breaks <-data.frame(start = c(0, 70, 140, 210),  # Create data with breaks
                                    end = c(70, 140, 210, 280),
                                    run = factor(c("low noise", "high noise", "low noise", "high noise")))

#create PLE group by quartile
data <-data %>% mutate(PLE_group = case_when(PLE<=-.6901455~ "Low PLE", PLE>=.52944 ~ "High PLE"))
data$PLE_group[is.na(data$PLE_group)]  <- "Medium PLE"


####################### Methods - FIGURE 1 #####################################
################################################################################
# B
task_struct<-ggplot()+geom_rect(data = data_breaks,aes(xmin = start,xmax = end, ymin = 0,ymax = 100,fill = run),alpha = 0.5)+ scale_fill_manual(values=c("#225c80", "#6699cc"))+
geom_line(data = master, aes(x = trial_all, y = true_mean, group=run), linetype= "longdash", size = 1.2)+
  geom_point(data = master, aes(x = trial_all,y=bag_location), colour = "white", size = 1)+guides(colour = "none", fill = "none")+    
  theme_classic()+ xlab("") + ylab("outcome")+ title("trial sequence")#+

#C
Av_errBased_pertrial<-data %>%
  group_by(master_trial_all) %>% 
  summarise_at(vars("errBased_pCha", "errBased_RU", "PE_sub", "bucket"), mean)
# create run variable
Av_errBased_pertrial$run<-c(rep(1,70), rep(2,70), rep(3,70),rep(4,70)) 

traj<- ggplot()+ geom_line(data = Av_errBased_pertrial, aes(x = master_trial_all, y = errBased_pCha, color = "CPP"))+
  geom_line(data = Av_errBased_pertrial, aes(x = master_trial_all, y = errBased_RU, color = "RU"))+theme_classic()+
  ylab("parameter") +xlab("trials")+labs(colour="Model parameter")+scale_color_manual(values=c("#D38D55", "#244376"))+theme(legend.position=c(.91,.9), legend.background = element_rect(fill="transparent"))

#D
# compute mean RU and pCha across all subs
task_struct_bucket_avsub<-ggplot()+geom_rect(data = data_breaks,aes(xmin = start,xmax = end, ymin = 0,ymax = 100,fill = run),alpha = 0.5)+scale_fill_manual(values=c("#225c80", "#6699cc"))+
  geom_line(data = master, aes(x = trial_all, y = true_mean, group=run), linetype= "longdash", size = 1.2)+
  geom_point(data = Av_errBased_pertrial, aes(x = master_trial_all,y=bucket), colour = "white", size =1)+guides(colour = "none", fill = "none")+    
 title("trial sequence")+theme_classic()+ theme(legend.position="none")+
  geom_bar(data = Av_errBased_pertrial, aes(y = abs(PE_sub), x = c(1:280)), stat="identity",alpha = 0.5,color = brewer.pal(3, "Spectral")[1],size = .8)+
  xlab("")+ylab("response")

ggarrange(task_struct, task_struct_bucket_avsub, traj, nrow = 3, labels = c("B","C","D"))


####################### FIGURE 2 ##################################
################################################################################

# A ========== Prediction error histogram ==========
coul <- brewer.pal(10, "Spectral") [1:10] # colors from Paired palette, choose first 10 and then 5-8 of those 10
hist_PE_ob<-ggplot(data, aes(x=PE_objective, fill=noise)) + geom_histogram(position = "identity", bins = 30, alpha =0.6)+scale_fill_manual(values=noise_coul)+xlab("Perofrmance error magnitude") +
  ylab("Frequency") +theme_classic() + theme(text = element_text(size = 14))+
  theme(text = element_text(size = 14),legend.position='none', plot.margin=unit(c(1,1,1,1), "cm"))
A<-ggarrange(hist_PE_ob)

# B ========== PE trials after CP by noise ==========
errBased_sums <- base::merge(data, sums, by.x=c("RedcapID"),
                             by.y=c("selfrep.id_nr"))

# compute PE mean for every TAC
#aggregate over trials separate for noise level
PE_blockt<-data %>%
  group_by(blocktrial,noise,RedcapID) %>% 
  summarise_at(vars("PE_objective_abs"), list(mean_sub=mean)) 

#aggregate over subjects for each TAC
PE_blockt<-PE_blockt %>%
  group_by(blocktrial, noise) %>% 
  dplyr::summarise_at(vars("mean_sub"), funs(meanperTAC=mean, sd = sd, n = dplyr::n(), se = sd/sqrt(n)))

#shift by 1 so that "blocktrial" represents trials AFTER change point  and blocktrial = 0 is a change point instead of blocktrial = 1
PE_blockt$blocktrial<-as.numeric(PE_blockt$blocktrial)-1

B<-PE_blockt %>% ggplot(.,aes(x = blocktrial,y = meanperTAC, color = noise, fill = noise)) + geom_point(aes(group = blocktrial), show.legend = FALSE)+geom_line()+
  geom_ribbon(aes(ymin=meanperTAC-se,ymax=meanperTAC+se),alpha=0.3, color = NA, show.legend = FALSE)+scale_fill_manual(values=noise_coul)+
  labs(title = '',  x = "Trials after change point", y = "PE_objective_abs", color = "noise")+
  theme_classic()+ylab('Performance error')+scale_color_manual(values=noise_coul) +coord_cartesian(xlim = c(0,18))+
  theme(text = element_text(size = 14), plot.margin=unit(c(1,1,1,1), "cm"),legend.position=c(.3,.9), legend.key.size = unit(.3, 'cm'), legend.key = element_blank())#, legend.background = element_rect(fill='transparent'))+ theme(axis.text = element_text(colour = "white"), axis.ticks = element_line(colour = "white"), axis.line.x.bottom=element_line(color="white"),axis.line.y =element_line(color="white"), panel.background = element_rect(fill = 'transparent', color = 'transparent'),rect = element_rect(fill = "transparent"), text = element_text(color = "white"), )

#C ========== Scatter Plot PE PLE ==========
##Sctater plot PE PLp
C<-ggscatter(sums_all,y ="PE_objective_abs", x ="PLE", ylab="Mean performance error per subject", xlab = "PLE score", size=.1, add = "reg.line",  # Add regressin line
                          add.params = list(color = "#c26102", fill = "#FDAE61"), # Customize reg. line
                          conf.int = TRUE, # Add confidence interval
                          cor.coef = TRUE, # Add correlation coefficient. see ?stat_cor
                          cor.coeff.args = list(method = "pearson", label.sep = ","),
                          cor.coef.size = 4, cor.coef.coord = c(1,13))+
                          scale_fill_manual(values=brewer.pal(11, "Spectral")[c(4,1)]) + theme(text = element_text(size = 14), plot.margin=unit(c(1,1,1,1), "cm"))

#D ========== Precision =============
#aggreagte
prec_blockt_PLE<-long_allprec_PLE %>%
  group_by(blocktrial,PLE_group,selfrep.id_nr) %>% 
  summarise_at(vars("precision"), list(mean_sub = mean),  na.rm = TRUE) 

#aggregate across subjects for each noise trial
prec_blockt_PLE<-prec_blockt_PLE %>%
  group_by(blocktrial, PLE_group) %>% 
  summarise_at(vars("mean_sub"), funs(meanperTAC=mean, sd = sd, n = dplyr::n(), se = sd/sqrt(n)))

D<-prec_blockt_PLE %>% ggplot(.,aes(x = blocktrial,y = meanperTAC, color = PLE_group, fill = PLE_group)) + geom_point(aes(group = blocktrial), show.legend = FALSE)+geom_line()+
   geom_ribbon(aes(ymin=meanperTAC-se,ymax=meanperTAC+se),alpha=0.2, color = NA, show.legend = FALSE)+scale_fill_manual(values=PLE_coul)+
   labs(x = "Trials after change point", y = "Precision", color = "PLE group")+  theme_classic()+ylab('Belief precision')+
   scale_color_manual(values=PLE_coul, breaks = c("Low PLE", "Medium PLE", "High PLE")) +coord_cartesian(xlim = c(0,18))+
  theme(text = element_text(size = 14), plot.margin=unit(c(1,1,1,1), "cm"),legend.position=c(.35,.85), legend.key.size = unit(.3, 'cm'), legend.background = element_rect(fill='transparent'))


df <- na.omit(data)%>%subset(., blocktrial==1); tac1<-ggplot(df, aes(x=LR))+geom_histogram(aes(y = after_stat(count / sum(count))), color="#c26102", fill="#FDAE61")+theme_classic()+theme(text = element_text(size = 14))+labs(x = "1 TAC", y = "")+scale_y_continuous(labels = scales::percent, limits = c(0,.5), breaks = c(0,.25,.5))+scale_x_continuous(breaks = c(0, 0.25, 0.5, 0.75, 1), label=c("0",".25",".5",".75","1"))
df <- na.omit(data)%>%subset(., blocktrial==2); tac2<-ggplot(df, aes(x=LR))+geom_histogram(aes(y = after_stat(count / sum(count))), color="#c26102", fill="#FDAE61")+theme_classic()+theme(text = element_text(size = 14))+labs(x = "2 TAC", y = "")+scale_y_continuous(labels = scales::percent, limits = c(0,.5), breaks = c(0,.25,.5))+scale_x_continuous(breaks = c(0, 0.25, 0.5, 0.75, 1),  label=c("0",".25",".5",".75","1"))
df <- na.omit(data)%>%subset(., blocktrial==5); tac5<-ggplot(df, aes(x=LR))+geom_histogram(aes(y = after_stat(count / sum(count))), color="#c26102", fill="#FDAE61")+theme_classic()+theme(text = element_text(size = 14))+labs(x = "5 TAC", y = "")+scale_y_continuous(labels = scales::percent, limits = c(0,.5), breaks = c(0,.25,.5))+scale_x_continuous(breaks = c(0, 0.25, 0.5, 0.75, 1),  label=c("0",".25",".5",".75","1"))
df <- na.omit(data)%>%subset(., blocktrial==10); tac10<-ggplot(df, aes(x=LR))+geom_histogram(aes(y = after_stat(count / sum(count))), color="#c26102", fill="#FDAE61")+theme_classic()+theme(text = element_text(size = 14))+labs(x = "10 TAC", y = "")+scale_y_continuous(labels = scales::percent, limits = c(0,.5), breaks = c(0,.25,.5))+scale_x_continuous(breaks = c(0, 0.25, 0.5, 0.75, 1), label=c("0",".25",".5",".75","1"))
df <- na.omit(data)%>%subset(., blocktrial==12); tac12<-ggplot(df, aes(x=LR))+geom_histogram(aes(y = after_stat(count / sum(count))), color="#c26102", fill="#FDAE61")+theme_classic()+theme(text = element_text(size = 14))+labs(x = "12 TAC", y = "")+scale_y_continuous(labels = scales::percent, limits = c(0,.5), breaks = c(0,.25,.5))+scale_x_continuous(breaks = c(0, 0.25, 0.5, 0.75, 1), label=c("0",".25",".5",".75","1"))
df <- na.omit(data)%>%subset(., blocktrial==15); tac15<- ggplot(df, aes(x=LR))+geom_histogram(aes(y = after_stat(count / sum(count))), color="#c26102", fill="#FDAE61")+theme_classic()+theme(text = element_text(size = 14))+labs(x = "15 TAC", y = "")+scale_y_continuous(labels = scales::percent, limits = c(0,.5), breaks = c(0,.25,.5))+scale_x_continuous(breaks = c(0, 0.25, 0.5, 0.75, 1), label=c("0",".25",".5",".75","1"))

E<-ggarrange(tac1, tac5, tac10, tac15, nrow = 1)+ theme(plot.margin=unit(c(1,1,1,1), "cm"))
E<- annotate_figure(E,top = text_grob("Histogram of learning rates at different trials after change point (TAC)", size = 14))
ABCD<-ggarrange(A,B,C,D,nrow=2,ncol = 2, labels = c("A","B","C","D"))
ABCDE<-ggarrange(ABCD, E, nrow = 2, labels=c("", "E"), heights = c(3,1))
tiff("figures/Figure2.tiff", units="in", width=10, height=12, res=300, compression = 'lzw')
ABCDE
dev.off()
####################### FIGURE 3 ##################################
################################################################################

###### Parameter estimates & Marginal effects ######################
set_theme(
  geom.outline.color = "antiquewhite4", 
  geom.outline.size = 1, 
  geom.label.size = 2,
  geom.label.color = "black",
  title.color = "#E2891F", 
  title.size = 1.5, 
  axis.angle.x = 0, 
  axis.textcolor = "black", 
  base = theme_classic()
)

names(model_reg_PLE$coefficients) <-c("(Intercept)" ,"β PE","β CPP","β RU")
paramEstimates <-plot_model(model_reg_PLE,show.values = TRUE, value.offset = .3)

PLEPE_marginaleffect<-  plot_model(model_reg_PLE, type = "eff", terms = "bePE")+labs(x = "β PE")
PLEpCha_marginaleffect <-  plot_model(model_reg_PLE, type = "eff", terms = "bePE_pCha")+labs(x = "β pCha", title="")
PLERU_marginaleffect<- plot_model(model_reg_PLE, type = "eff", terms = "bePE_RU")+labs(x = "β RU", title="")

marginalEffects<-ggarrange(PLEPE_marginaleffect, PLEpCha_marginaleffect, PLERU_marginaleffect, nrow = 3, labels = c("B","C", "D"))
ggarrange(paramEstimates, marginalEffects, ncol = 2, labels = c("A",""))


############### FIGURE 4 ##############################
################################################################################
#matrix of beta weights
mycols<-colorRampPalette(c("#3288BD", "white"))(256)

#Selfrep
# Correlation matrix
mysums<-subset(coefficients, select = c('zPDI','zASI','zCAPS','zOCIR','zSTAIT','zAUDIT','zAES')) 
corr_selfrep<-as.ggplot(ggcorrplot(cor(mysums), p.mat = cor.mtest(mysums)$p, sig.level = 0.001, colors = c("#3288BD","white", "#E2891F"), type = 'lower', lab = TRUE, hc.order=FALSE))
ph_selfrep<-as.ggplot(pheatmap(beta_mat_selfrep, display_numbers = TRUE, fontsize=20, col = mycols,  cluster_rows=F, cluster_cols=F, cellwidth=60))
ggarrange(corr_selfrep, ph_selfrep, labels = c('A', 'B'))


