## Lack of power
dfExpandPower <- expand.grid(nb_observations = 50,
                             nb_genes = 50,
                             prop_sig_gene = 0.5,
                             variance = 0.2,
                             case = c(1, 2, 3),
                             type = c("A", "B", "C"),
                             censoring = c(0, 0.3),
                             nb_permutation = 2,
                             prop_two_periods = FALSE)
## Proportionality
dfProportionality <- expand.grid(nb_observations = 50,
                                 nb_genes = 50,
                                 prop_sig_gene = c(0.05, 0.10, 0.2),
                                 variance = 0.2,
                                 case = c(1, 2, 3),
                                 type = c("A", "B", "C"),
                                 censoring = c(0, 0.3),
                                 nb_permutation = 2,
                                 prop_two_periods = TRUE)

## All scenarios
nb_rep = 500
dfScenario <- rbind(dfExpandPower, dfProportionality) %>%
  slice(rep(row_number(), nb_rep)) %>%
  as_tibble

saveRDS(dfScenario, file = "data/dfScenario.rds")

# iter <- 1
# 
# vec_hp <- dfScenario[iter,]
# 
# result <- fct_simulation_paper(nb_observations = vec_hp[["nb_observations"]],
#                                nb_genes = vec_hp[["nb_genes"]],
#                                prop_sig_gene =  vec_hp[["prop_sig_gene"]],
#                                variance =  vec_hp[["variance"]],
#                                case =  vec_hp[["case"]],
#                                type =  vec_hp[["type"]],
#                                censoring =  vec_hp[["censoring"]],
#                                nb_permutation =  vec_hp[["nb_permutation"]],
#                                prop_two_periods =  vec_hp[["prop_two_periods"]]) %>%
#   mutate(iter = iter)
