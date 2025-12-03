
# Power -------------------------------------------------------------------

## launch with 1000 repetitions (500 done before but I wrote 1,000 ...)

df_rev1 <- expand.grid(nb_observations = c(50,100),
                       nb_genes = c(10, 50, 100),
                       prop_sig_gene = c(0.2, 0.05),
                       variance = 0.2,
                       case = c(4, 5, 6),
                       type = c("G", "H", "I"),
                       censoring = c(0.3),
                       nb_permutation = 1000,
                       nperm_sGBJ = 1000,
                       prop_two_periods = FALSE,
                       method = "All")
## high gene correlation
df_rev2 <- expand.grid(nb_observations = c(50,100),
                       nb_genes = c(10, 50, 100),
                       prop_sig_gene = c(0.2),
                       variance = 0.2,
                       case = c(7),
                       type = c("G"),
                       censoring = c(0.3),
                       nb_permutation = 1000,
                       nperm_sGBJ = 1000,
                       prop_two_periods = FALSE,
                       method = "All")

### vary sGBJ permutations number
df_rev3 <- expand.grid(nb_observations = c(50,100),
                       nb_genes = c(10, 50, 100),
                       prop_sig_gene = c(0.2),
                       variance = 0.2,
                       case = c(4),
                       type = c("G"),
                       censoring = c(0.3),
                       nb_permutation = 1000,
                       nperm_sGBJ = c(500, 2000),
                       prop_two_periods = FALSE,
                       method = "SGBJ")

df_rev_resp_round_1 <- dplyr::bind_rows(df_rev1, df_rev2, df_rev3)

saveRDS(df_rev_resp_round_1, file = "data/df_rev_resp_round_1.rds")


# Type I error ------------------------------------------------------------

## launch with 2,000 repetitions

df_rev_resp_round_1_Z <- df_rev_resp_round_1 |> 
  mutate(type = "Z") |> 
  distinct()

saveRDS(df_rev_resp_round_1_Z, file = "data/df_rev_resp_round_1_Z.rds")
