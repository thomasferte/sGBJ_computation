library(dplyr)
# Power -------------------------------------------------------------------

df_rev_resp_round_1_addition <- expand.grid(nb_observations = c(1000),
                                            nb_genes = c(100),
                                            prop_sig_gene = c(0.2),
                                            variance = 0.2,
                                            case = c(4, 5, 6),
                                            type = c("G", "H", "I"),
                                            censoring = c(0.3),
                                            nb_permutation = 1000,
                                            nperm_sGBJ = 1000,
                                            prop_two_periods = FALSE,
                                            method = "All")

saveRDS(df_rev_resp_round_1_addition, file = "data/df_rev_resp_round_1_addition.rds")


# Type I error ------------------------------------------------------------

## launch with 2,000 repetitions

df_rev_resp_round_1_addition_Z <- df_rev_resp_round_1_addition |> 
  mutate(type = "Z",
         method = "All") |> 
  distinct()

saveRDS(df_rev_resp_round_1_addition_Z, file = "data/df_rev_resp_round_1_addition_Z.rds")
