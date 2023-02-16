#' Function to retrieve p-values from the different scenarios
#'
#' @param nb_observations Number of observations (default = 50)
#' @param nb_genes Number of genes (default = 50)
#' @param prop_sig_gene Proportion of significant gene (default = 0.2)
#' @param variance Variance (default = 2)
#' @param case Case of simulation
#' @param type Type of simulation
#' @param censoring Censoring proportion
#' @param nb_permutation Number of permutation for other tests
#' @param prop_two_periods Should the beta be divided by 2 after a given period (not respect proportionality assumption)
#' @param slam A constant used in the exponential simulation (default = 0.005)
#'
#' @return A dataframe with the different p-values
#' @export
fct_simulation_paper <- function(nb_observations = 50,
                                 nb_genes = 50,
                                 prop_sig_gene = 0.2,
                                 variance = 0.2,
                                 case = 2,
                                 type = "A",
                                 censoring = 0.3,
                                 nb_permutation = 1000,
                                 prop_two_periods = FALSE,
                                 slam = 0.005) {
  ##### generate data #####
  dfdata <- fct_generate_data(
    case = case,
    variance = variance,
    type = type,
    prop_sig_gene = prop_sig_gene,
    nb_genes = nb_genes,
    nb_observations = nb_observations,
    censoring = censoring,
    vec_beta = vec_beta,
    prop_two_periods = prop_two_periods,
    slam = slam,
    x = x
  )
  
  ##### sGBJ #####
  resSGBJ <-
    sGBJ::sGBJ(
      surv = survival::Surv(dfdata$time, dfdata$event),
      factor_matrix = dfdata %>% select(-time,-event) %>% as.matrix()
    )
  #Global boost test
  gbst <-
    globalboosttest::globalboosttest(
      X = dfdata %>% select(-time,-event) %>% as.matrix(),
      Y = survival::Surv(dfdata$time, dfdata$event),
      Z = NULL,
      nperm = nb_permutation,
      mstop = 500,
      pvalueonly = TRUE
    )
  
  ##### Other methods #####
  ots <- statsTest(
    vectime = dfdata$time,
    vecevent = dfdata$event,
    x = dfdata %>% select(-time,-event) %>% as.matrix()
  )
  rts <- matrix(0, nrow = 2, ncol = nb_permutation)
  
  for (b in 1:nb_permutation) {
    if (b %% 10 == 0) {
      print(b)
    }
    
    seed <- as.numeric(Sys.time()) + b
    
    set.seed(seed)
    
    dfdatapermuted <- dfdata %>%
      dplyr::select(time, event) %>%
      dplyr::slice_sample(prop = 1, replace = TRUE)
    
    rts[, b] <- statsTest(
      vectime = dfdatapermuted$time,
      vecevent = dfdatapermuted$event,
      x = dfdata %>% select(-time,-event) %>% as.matrix()
    )
  }
  p.pvalue <- c(resSGBJ$sGBJ_pvalue, apply((rts > ots), 1, mean), as.numeric(gbst$pvalue))
  
  res <- data.frame(
    p_value = p.pvalue,
    method = c("sGBJ", "Global Test", "Wald Test", "Global Boost Test")
  )
  
  return(res)
}
