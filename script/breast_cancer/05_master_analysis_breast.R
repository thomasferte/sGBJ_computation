taskid <- Sys.getenv('SLURM_ARRAY_TASK_ID')
print(taskid)
######## PATWAY ANALYSIS OF BREAST CANCER FILE #########
##### load packages #####
library(dplyr)
library(ggplot2)
library(survival)
library(survminer)
library(parallel)

##### survival analysis #####
lsdata <- readRDS(file = "data/breast_cancer/datamanaged.rds")

lapply(X = list.files("functions/", full.names = T), source)

ls_pathways <- lsdata$pathways
df_data <- lsdata$data

##### analysis
df_analysis_breast <- fct_breast_cancer_analysis(df_data = df_data,
                                                 ls_pathways = ls_pathways[taskid],
                                                 vec_covariates = "age",
                                                 nb_permutation = 1000)

saveRDS(df_analysis_breast, file = here::here(paste0("results/breast_cancer/df_analysis_breast_pw_", taskid, ".rds")))
