taskid <- as.numeric(Sys.getenv('SLURM_ARRAY_TASK_ID'))
print(taskid)
######## PATWAY ANALYSIS OF BREAST CANCER FILE #########
##### load packages #####
library(dplyr)
library(survival)

##### survival analysis #####
lsdata <- readRDS(file = "data/breast_cancer/datamanaged2.rds")

lapply(X = list.files("functions/", full.names = T), source)

ls_pathways <- lsdata$pathways
df_data <- lsdata$data

##### get pathway
vec_pathway <- unique(lsdata$pathways$gs_name)
pathway_taskid <- vec_pathway[taskid]
gene_taskid <- lsdata$pathways |> 
  filter(gs_name == pathway_taskid) |> 
  pull(gene_symbol)

ls_pathway_taskid <- setNames(list(gene_taskid), pathway_taskid)

##### analysis
df_analysis_breast <- fct_breast_cancer_analysis(df_data = df_data,
                                                 ls_pathways = ls_pathway_taskid,
                                                 vec_covariates = "age",
                                                 nb_permutation = 1000)

saveRDS(df_analysis_breast, file = here::here(paste0("results/breast_cancer/df_analysis_breast_pw_", taskid, ".rds")))
