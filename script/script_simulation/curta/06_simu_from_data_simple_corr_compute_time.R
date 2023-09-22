##### load packages and functions
library(dplyr)
library(parallel)

lapply(list.files(path = "functions/", full.names = TRUE),
       source)

##### load data
dfScenario <- readRDS("data/dfScenarioSimpleCorr.rds") %>%
  tibble::rowid_to_column(var = "hp_row")

##### start computation
parallel_fct <- function(row) {
  fct_simulation_paper(
    methods = c("sgbj", "gbt", "gt", "wald"),
    nb_observations = as.numeric(row[["nb_observations"]]),
    nb_genes = as.numeric(row[["nb_genes"]]),
    prop_sig_gene = as.numeric(row[["prop_sig_gene"]]),
    variance = as.numeric(row[["variance"]]),
    case = row[["case"]],
    type = row[["type"]],
    censoring = as.numeric(row[["censoring"]]),
    nb_permutation = as.numeric(row[["nb_permutation"]]),
    prop_two_periods = row[["prop_two_periods"]],
    nperm_sGBJ = as.numeric(row[["nb_permutation"]])
  ) %>%
    mutate(hp_row = row[["hp_row"]])
}

# Split the data into chunks for parallel processing
chunks <- apply(dfScenario, 1, function(x) return(x), simplify = FALSE)

# Parallel execution using 12 cores
result_list <- mclapply(chunks, parallel_fct, mc.cores = nrow(dfScenario))

# Combine the results into a single data frame
res <- bind_rows(result_list)

saveRDS(res, file = "data/result_11020779_time.rds")
