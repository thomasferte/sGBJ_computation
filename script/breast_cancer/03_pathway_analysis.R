##### load packages #####
library(dplyr)
library(ggplot2)
library(survival)
library(survminer)
library(parallel)

##### survival analysis #####
lsdata <- readRDS(file = "data/brest_cancer/datamanaged.rds")
source("script/breast_cancer/liste70pathways.R")

##### marginal #####
df_res_marginal <- mclapply(X = liste_70,
                            mc.cores = 3,
                            FUN = function(pathway_i){
                              vec_pathways <- lsdata$pathways[[pathway_i]]
                              
                              surv_obj <- survival::Surv(time = lsdata$data$time,
                                                         event = lsdata$data$event)
                              
                              factor_matrix <- lsdata$data %>%
                                select(any_of(vec_pathways))
                              
                              covariates <- lsdata$data %>% select(age)
                              
                              test <- sGBJ::sGBJ(surv = surv_obj,
                                                 factor_matrix = factor_matrix,
                                                 covariates = covariates)
                              
                              res <- data.frame(pathway = pathway_i,
                                                nb_genes = ncol(factor_matrix),
                                                p_value = test$sGBJ_pvalue)
                              
                              return(res)
                            }) %>%
  bind_rows() %>%
  mutate(p_value_adjusted = p.adjust(p = p_value, method = "hochberg"))

saveRDS(df_res_marginal, file = "data/brest_cancer/df_res_marginal.rds")

##### stratified #####
df_res_stratified <- mclapply(X = liste_70,
                              mc.cores = 3,
                              FUN = function(pathway_i){
                                vec_pathways <- lsdata$pathways[[pathway_i]]
                                vec_grade <- unique(lsdata$data$grade)
                                
                                res <- lapply(X = vec_grade,
                                              FUN = function(grade_i){
                                                dfdata <- lsdata$data %>% filter(grade == grade_i)
                                                
                                                surv_obj <- survival::Surv(time = dfdata$time,
                                                                           event = dfdata$event)
                                                
                                                factor_matrix <- dfdata %>%
                                                  select(any_of(vec_pathways))
                                                
                                                covariates <- dfdata %>% select(age)
                                                
                                                test <- sGBJ::sGBJ(surv = surv_obj,
                                                                   factor_matrix = factor_matrix,
                                                                   covariates = covariates)
                                                
                                                res <- data.frame(pathway = pathway_i,
                                                                  grade = grade_i,
                                                                  nb_genes = ncol(factor_matrix),
                                                                  p_value = test$sGBJ_pvalue)         
                                                
                                                return(res)
                                              }) %>%
                                  bind_rows()
                                
                                return(res)
                              }) %>%
  bind_rows() %>%
  group_by(grade) %>%
  mutate(p_value_adjusted = p.adjust(p = p_value, method = "hochberg"))

saveRDS(df_res_stratified, file = "data/brest_cancer/df_res_stratified.rds")
