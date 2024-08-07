## Proportionality
dfOriginal <- expand.grid(nb_observations = 50,
                          nb_genes = 50,
                          prop_sig_gene = c(0.05, 0.10, 0.2),
                          variance = 0.2,
                          case = c(1, 2, 3),
                          type = c("A", "B", "C"),
                          censoring = c(0, 0.3),
                          nb_permutation = 1000,
                          prop_two_periods = FALSE)

## All scenarios
saveRDS(dfOriginal, file = "data/dfScenarioOriginal.rds")
