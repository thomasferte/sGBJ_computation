## Lack of power
dfExpandPower <- expand.grid(nb_observations = 50,
                             nb_genes = 50,
                             prop_sig_gene = 0.5,
                             variance = 0.2,
                             case = c(1, 2, 3),
                             type = c("A", "B", "C"),
                             censoring = c(0, 0.3),
                             nb_permutation = 1000,
                             prop_two_periods = FALSE)
## Proportionality
dfProportionality <- expand.grid(nb_observations = 50,
                                 nb_genes = 50,
                                 prop_sig_gene = c(0.05, 0.10, 0.2),
                                 variance = 0.2,
                                 case = c(1, 2, 3),
                                 type = c("A", "B", "C"),
                                 censoring = c(0, 0.3),
                                 nb_permutation = 1000,
                                 prop_two_periods = TRUE)

## All scenarios
dfScenario <- rbind(dfExpandPower, dfProportionality)

saveRDS(dfScenario, file = "data/dfScenario.rds")
