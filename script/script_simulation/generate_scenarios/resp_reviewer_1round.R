## 1000 repetitions (500 done before but we wrote 1,000)
df_rev1 <- expand.grid(nb_observations = c(50,100),
                       nb_genes = c(10, 50, 1000),
                       prop_sig_gene = c(0.2, 0.05),
                       variance = 0.2,
                       case = c(4, 5, 6, 7),
                       type = c("G", "H", "I"),
                       censoring = c(0.3),
                       nb_permutation = 1000,
                       nperm_sGBJ = 1000,
                       prop_two_periods = FALSE,
                       method = "All")

df_rev2_c1_A <- expand.grid(nb_observations = c(50,100),
                            nb_genes = c(10, 50, 1000),
                            prop_sig_gene = c(0.2),
                            variance = 0.2,
                            case = c(4, 5, 6, 7),
                            type = c("G"),
                            censoring = c(0.3),
                            nb_permutation = 1000,
                            nperm_sGBJ = c(500, 2000),
                            prop_two_periods = FALSE,
                            method = "SGBJ")

df_rev_resp_round_1 <- dplyr::bind_rows(df_rev1, df_rev2_c1_A)

saveRDS(df_rev_resp_round_1, file = "data/df_rev_resp_round_1.rds")


## 2,000 repetitions
df_rev_resp_round_1_Z <- expand.grid(nb_observations = c(50,100),
                                     nb_genes = c(10, 50, 1000),
                                     prop_sig_gene = c(0.2, 0.05),
                                     variance = 0.2,
                                     case = c(4, 5, 6, 7),
                                     type = c("Z"),
                                     censoring = c(0.3),
                                     nb_permutation = 1000,
                                     nperm_sGBJ = 1000,
                                     prop_two_periods = FALSE,
                                     method = "All")

saveRDS(df_rev_resp_round_1_Z, file = "data/df_rev_resp_round_1_Z.rds")
