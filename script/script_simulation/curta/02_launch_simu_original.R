print(paste0("Start at ", Sys.time(), "..."))

slar_taskid <- as.numeric(Sys.getenv("SLURM_ARRAY_TASK_ID"))
# slar_taskid <- 1
slar_jobid <- as.numeric(Sys.getenv("SLURM_ARRAY_JOB_ID"))


##### load packages and functions
message("load packages and functions")

library(dplyr)

lapply(list.files(path = "functions/", full.names = TRUE),
       source)

##### load data
message("load dfScenario")

dfScenario <- readRDS("data/dfScenarioOriginal.rds")
hp_row <- slar_taskid
vec_hp <- dfScenario[hp_row,]

##### start computation
message("start computation")

res <- pbapply::pblapply(1:500,
                         FUN = function(iter){
                           res <- fct_simulation_paper(nb_observations = vec_hp[["nb_observations"]],
                                                       nb_genes = vec_hp[["nb_genes"]],
                                                       prop_sig_gene =  vec_hp[["prop_sig_gene"]],
                                                       variance =  vec_hp[["variance"]],
                                                       case =  vec_hp[["case"]],
                                                       type =  vec_hp[["type"]],
                                                       censoring =  vec_hp[["censoring"]],
                                                       nb_permutation =  vec_hp[["nb_permutation"]],
                                                       prop_two_periods =  vec_hp[["prop_two_periods"]]) %>%
                             mutate(hp_row = hp_row,
                                    iter = iter)
                           
                           return(res)
                         }) %>%
  bind_rows()

##### save results
print(paste0("Saving start at ", Sys.time(), "..."))

subDir <- paste0("data/result_simu/result_", slar_jobid)
if (!file.exists(subDir)){
  dir.create(subDir)
}

date_str <- gsub(x = Sys.Date(),"-","")

filename_r <- paste0(subDir, "/result_job",
                     slar_taskid, "_", date_str, ".rds")

saveRDS(res, file = filename_r)

print(paste0("Saving end at ", Sys.time(), "..."))
