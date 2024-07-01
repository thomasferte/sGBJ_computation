taskid <- as.numeric(Sys.getenv('SLURM_ARRAY_TASK_ID'))
print(taskid)
######## PATWAY ANALYSIS OF REMBRANDT FILE #########
##### load packages #####
library(dplyr)
library(survival)

lapply(list.files(path = here::here("functions"), full.names = TRUE), source)

##### load data #####
df_rembrandt <- fct_load_clean_rembrandt()

##### load pathways #####
pathways = GSA::GSA.read.gmt("data/rembrandt/c6.all.v7.1.symbols.gmt")
liste_pathways=pathways$genesets
liste_names=pathways$geneset.names
names(liste_pathways) <- liste_names

##### analysis
df_analysis_rembrandt <- fct_breast_cancer_analysis(df_data = df_rembrandt |> 
                                                      rename(grade = DISEASE_TYPE,
                                                             time = OVERALL_SURVIVAL_MONTHS,
                                                             event = EVENT_OS),
                                                    ls_pathways = liste_pathways[taskid],
                                                    vec_covariates = c("AGE_RANGE", "GENDER"),
                                                    nb_permutation = 1000)

saveRDS(df_analysis_rembrandt, file = here::here(paste0("results/rembrandt/df_analysis_rembrandt_pw_", taskid, ".rds")))
