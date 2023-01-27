##### load functions and package #####

source(file = "functions/fct_generate_varcovar.R")
source(file = "functions/fct_generate_beta.R")
source(file = "functions/fct_generate_survival_data.R")
source(file = "functions/fct_generate_data.R")
source(file = "functions/statsTest.R")

library(dplyr)

##### hyperparameters #####

nb_observations = 50
nb_genes = 50
prop_sig_gene = 0.2
variance = 0.2
case = 2
type = "A"
censoring = 0.3
nb_permutation = 2

##### generate data #####

dfdata <- fct_generate_data(case = case,
                            variance = variance,
                            type = type,
                            prop_sig_gene = prop_sig_gene,
                            nb_genes = nb_genes,
                            censoring = censoring,
                            vec_beta = vec_beta,
                            x = x)

##### sGBJ #####
resSGBJ <- sGBJ::sGBJ(surv = Surv(dfdata$time, dfdata$event),
                      factor_matrix = dfdata %>% select(-time, -event) %>% as.matrix())

##### Other methods #####
ots <- statsTest(time = dfdata$time, event = dfdata$event, x = dfdata %>% select(-time, -event) %>% as.matrix())
rts<-matrix(0,nrow=3,ncol=nb_permutation)
for(b in 1:nb_permutation){
  print(b)
  
  permute<-sample(1:ns)
  
  dfdatapermuted <- dfdata %>%
    select(time, event) %>%
    sample_frac(size = 1, replace = TRUE) %>%
    bind_cols(dfdata %>%
                select(-c(time, event)))
  
  rts[,b]<-statsTest(time = dfdatapermuted$time,
                     event = dfdatapermuted$event,
                     x = dfdatapermuted %>% select(-time, -event) %>% as.matrix())
}
p.pvalue<-apply((rts>ots),1,mean)

##### save results #####