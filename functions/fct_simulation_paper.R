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
#' @param nperm_sGBJ Nb of permutation (default = 300)
#'
#' @return A dataframe with the different p-values
#' @export
fct_simulation_paper <- function(methods = c("sgbj", "gbt", "other", "rf"),
                                 nb_observations = 50,
                                 nb_genes = 50,
                                 prop_sig_gene = 0.2,
                                 variance = 0.2,
                                 case = 2,
                                 type = "A",
                                 censoring = 0.3,
                                 nb_permutation = 1000,
                                 prop_two_periods = FALSE,
                                 nperm_sGBJ = 300,
                                 slam = 0.005) {
  ls_pvalue <-
    list(
      "sGBJ" = NA,
      "Global Test" = NA,
      "Wald Test" = NA,
      "Global Boost Test" = NA,
      "RF" = NA
    )
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
  if("sgbj" %in% methods){
    resSGBJ <-
      sGBJ::sGBJ(
        surv = survival::Surv(dfdata$time, dfdata$event),
        factor_matrix = dfdata %>% select(-time,-event) %>% as.matrix(),
        nperm = nperm_sGBJ
      )$sGBJ_pvalue
    
    ls_pvalue$sGBJ <- resSGBJ
  }
  
  #Global boost test
  if("gbt" %in% methods){
    gbst <-
      globalboosttest::globalboosttest(
        X = dfdata %>% select(-time,-event) %>% as.matrix(),
        Y = survival::Surv(dfdata$time, dfdata$event),
        Z = NULL,
        nperm = nb_permutation,
        mstop = 500,
        pvalueonly = TRUE
      )$pvalue[1]
    
    ls_pvalue$`Global Boost Test` <- gbst
  }
  
  ##### Other methods #####
  if("other" %in% methods){
    ots <- statsTest(
      vectime = dfdata$time,
      vecevent = dfdata$event,
      x = dfdata %>% select(-time,-event) %>% as.matrix()
    )
    rts <- matrix(0, nrow = 2, ncol = nb_permutation)
    
    for (b in 1:nb_permutation) {
      if (b %% 100 == 0) {
        print(b)
      }
      
      seed <- as.numeric(Sys.time()) + b
      
      set.seed(seed)
      
      dfdatapermuted <- dfdata %>%
        dplyr::select(time, event) %>%
        dplyr::slice_sample(prop = 1, replace = FALSE)
      
      rts[, b] <- statsTest(
        vectime = dfdatapermuted$time,
        vecevent = dfdatapermuted$event,
        x = dfdata %>% select(-time,-event) %>% as.matrix()
      )
    }
    vec_pvalue <- apply((rts > ots), 1, mean)
    
    ls_pvalue$`Global Test` <- vec_pvalue[1]
    ls_pvalue$`Wald Test` <- vec_pvalue[2]
  }
  
  if("rf" %in% methods){
    p_val_rf <- rfpermutation(dfdata = dfdata, nb_permutation = nb_permutation)
    
    ls_pvalue$RF <- p_val_rf
  }
  
  res <- data.frame(
    p_value = ls_pvalue %>% unlist(),
    method = names(ls_pvalue)
  ) %>%
    na.omit() %>%
    tibble::remove_rownames()
  
  return(res)
}
