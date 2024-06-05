# function to perform all 4 tests on a dataset depending on genes and covariates
fct_perform_tests <- function(df_data_analysis,
                              vec_genes_of_pathway,
                              vec_covariates,
                              nb_permutation = 1000){
  
  surv_obj <- survival::Surv(time = df_data_analysis$time,
                             event = df_data_analysis$event)
  
  factor_matrix <- df_data_analysis %>% select(any_of(vec_genes_of_pathway))
  
  covariates <- df_data_analysis %>% select(any_of(vec_covariates))
  
  all_expl_features <- bind_cols(factor_matrix, covariates)
  
  alternative_hyp <- paste0("~ ",
                            paste0("`", colnames(factor_matrix), "`", collapse = " + "))
  null_hyp <- paste0("~ ",
                     paste0(colnames(covariates), collapse = " + "))
  
  ##### TESTS
  ### sGBJ
  message("--- sGBJ")
  time_start <- Sys.time()
  sGBJ <- sGBJ::sGBJ(surv = surv_obj,
                     factor_matrix = factor_matrix,
                     covariates = covariates,
                     nperm = nb_permutation)$sGBJ_pvalue
  time_end <- Sys.time()
  time_sGBJ <- difftime(time_end, time_start, units = "secs")
  ### GBT
  message("--- GBT")
  time_start <- Sys.time()
  GBT <- globalboosttest::globalboosttest(
    X = factor_matrix,
    Y = surv_obj,
    Z = covariates,
    nperm = nb_permutation,
    mstop = 500,
    pvalueonly = TRUE
  )$pvalue |>
    as.numeric()
  time_end <- Sys.time()
  time_GBT <- difftime(time_end, time_start, units = "secs")
  ### WALD
  message("--- Wald")
  time_start <- Sys.time()
  wald_pval <- Wald_Test_Perm(vectime = df_data_analysis$time,
                              vecevent = df_data_analysis$event,
                              x = as.matrix(factor_matrix),
                              covariates = as.matrix(covariates),
                              nb_permutation = nb_permutation)
  time_end <- Sys.time()
  time_wald <- difftime(time_end, time_start, units = "secs")
  
  ### GT
  message("--- Global Test")
  time_start <- Sys.time()
  GT<-globaltest::gt(response = surv_obj,
                     data = all_expl_features,
                     null = as.formula(null_hyp),
                     alternative = as.formula(alternative_hyp),
                     model="cox",
                     permutations = 0) |>
    globaltest::p.value()
  time_end <- Sys.time()
  time_gt <- difftime(time_end, time_start, units = "secs")
  
  ##### RESULTS
  res <- data.frame(nb_genes = ncol(factor_matrix),
                    sGBJ = sGBJ,
                    time_sGBJ = time_sGBJ,
                    GBT = GBT,
                    time_GBT = time_GBT,
                    GT = GT,
                    time_GT = time_gt,
                    Wald = wald_pval,
                    time_Wald = time_wald)         
  
  return(res)
}