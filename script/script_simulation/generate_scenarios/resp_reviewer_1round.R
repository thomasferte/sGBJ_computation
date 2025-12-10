library(dplyr)
# Power -------------------------------------------------------------------

df_rev_resp_round_1 <- list(
  ## Add Cauchy + HM
  expand.grid(nb_observations = c(50,100),
              nb_genes = c(10, 50),
              prop_sig_gene = c(0.2),
              variance = 0.2,
              case = c(4, 5, 6),
              type = c("G", "H", "I"),
              censoring = c(0.3),
              nb_permutation = 1000,
              nperm_sGBJ = 1000,
              prop_two_periods = FALSE,
              method = "Cauchy;HM"),
  ## 100 genes
  expand.grid(nb_observations = c(50,100),
              nb_genes = c(100),
              prop_sig_gene = c(0.2),
              variance = 0.2,
              case = c(4, 5, 6),
              type = c("G", "H", "I"),
              censoring = c(0.3),
              nb_permutation = 1000,
              nperm_sGBJ = 1000,
              prop_two_periods = FALSE,
              method = "All"),
  ## high gene correlation
  expand.grid(nb_observations = c(50, 100),
              nb_genes = c(10, 50, 100),
              prop_sig_gene = c(0.2),
              variance = 0.2,
              case = c(7),
              type = c("G"),
              censoring = c(0.3),
              nb_permutation = 1000,
              nperm_sGBJ = 1000,
              prop_two_periods = FALSE,
              method = "All"),
  ## nb sign genes
  expand.grid(nb_observations = c(50,100),
              nb_genes = c(10, 50, 100),
              prop_sig_gene = c(0.05, 0.1),
              variance = 0.2,
              case = c(6),
              type = c("G"),
              censoring = c(0.3),
              nb_permutation = 1000,
              nperm_sGBJ = 1000,
              prop_two_periods = FALSE,
              method = "All")
) |> 
  dplyr::bind_rows()

saveRDS(df_rev_resp_round_1, file = "data/df_rev_resp_round_1.rds")


# Type I error ------------------------------------------------------------

## launch with 2,000 repetitions

df_rev_resp_round_1_Z <- df_rev_resp_round_1 |> 
  mutate(type = "Z",
         method = "All") |> 
  distinct()

saveRDS(df_rev_resp_round_1_Z, file = "data/df_rev_resp_round_1_Z.rds")
