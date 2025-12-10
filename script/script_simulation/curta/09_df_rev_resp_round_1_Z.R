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

dfScenario <- readRDS("data/df_rev_resp_round_1_Z.rds") %>%
  tibble::rowid_to_column(var = "hp_row")

##### start computation
message("start computation")

res <- pbapply::pbapply(X = dfScenario,
                        MARGIN = 1,
                        FUN = function(row){
                          
                          print(row[["hp_row"]])
                          
                          if(as.character(row[["method"]]) == "All"){
                            vec_methods = c("sgbj", "gbt", "gt", "wald", "Cauchy", "HM")
                          } else {
                            vec_methods = strsplit(as.character(row[["method"]]), split = ";") |> 
                              unlist()
                          }
                          
                          fct_simulation_paper(methods = vec_methods,
                                               nb_observations = as.numeric(row[["nb_observations"]]),
                                               nb_genes = as.numeric(row[["nb_genes"]]),
                                               prop_sig_gene = as.numeric(row[["prop_sig_gene"]]),
                                               variance =  as.numeric(row[["variance"]]),
                                               case =  row[["case"]],
                                               type =  row[["type"]],
                                               censoring =  as.numeric(row[["censoring"]]),
                                               nb_permutation = 25,
                                               prop_two_periods =  row[["prop_two_periods"]],
                                               nperm_sGBJ = 25) %>%
                            mutate(hp_row = row[["hp_row"]],
                                   iter = slar_taskid) %>%
                            return()
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
