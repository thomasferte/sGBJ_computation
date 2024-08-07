## Lack of power
dfScenario <- expand.grid(nb_observations = c(50,100),
                          nb_genes = c(10,50,200),
                          prop_sig_gene = c(0.2, 0.5),
                          variance = 0.2,
                          case = c(4, 5),
                          type = c("D", "E", "F"),
                          censoring = c(0, 0.3),
                          nb_permutation = 1000,
                          prop_two_periods = FALSE)

# ## Proportionality
# dfProportionality <- expand.grid(nb_observations = 50,
#                                  nb_genes = 50,
#                                  prop_sig_gene = c(0.05, 0.10, 0.2),
#                                  variance = 0.2,
#                                  case = c(1, 2, 3),
#                                  type = c("A", "B", "C"),
#                                  censoring = c(0, 0.3),
#                                  nb_permutation = 1000,
#                                  prop_two_periods = TRUE)

## All scenarios
# dfScenario <- rbind(dfExpandPower, dfProportionality)

saveRDS(dfScenario, file = "data/dfScenario_breast_rembrandt.rds")

#### Exclude already done

vec_done <- list.files(path = "data/result_simu_rembrandt_breast/result_9799043/") %>%
  gsub(replacement = "", pattern = "result_job") %>%
  gsub(replacement = "", pattern = "_.*")

readRDS(file = "data/dfScenario_breast_rembrandt.rds") %>%
  tibble::rowid_to_column() %>%
  filter(!rowid %in% vec_done) %>%
  select(-rowid) %>%
  saveRDS(file = "data/dfScenario_breast_rembrandt_to_finish.rds")

##### new set exp with correlated beta
expand.grid(nb_observations = c(50,100),
            nb_genes = c(10,50),
            prop_sig_gene = c(0.2),
            variance = 0.2,
            case = c(4, 5),
            type = c("G", "H", "I"),
            censoring = c(0.3),
            nb_permutation = 1000,
            prop_two_periods = FALSE) |>
  saveRDS(file = "data/dfScenarioCorr.rds")

##### new set exp with simple correlation setting
expand.grid(nb_observations = c(50,100),
            nb_genes = c(10,50),
            prop_sig_gene = c(0.2),
            variance = 0.2,
            case = c(6),
            type = c("G", "H", "I"),
            censoring = c(0.3),
            nb_permutation = 1000,
            prop_two_periods = FALSE) |>
  saveRDS(file = "data/dfScenarioSimpleCorr.rds")

##### new set exp for alpha risk
expand.grid(nb_observations = c(50,100),
            nb_genes = c(10,50),
            prop_sig_gene = c(0.2),
            variance = 0.2,
            case = c(4, 5, 6),
            type = c("Z"),
            censoring = c(0.3),
            nb_permutation = 1000,
            prop_two_periods = FALSE) |>
  saveRDS(file = "data/dfScenarioAlpha.rds")



