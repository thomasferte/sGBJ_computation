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
fct_simulation_paper <- function(methods = c("sgbj", "gbt", "gt", "wald", "rf"),
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
  
  ls_time <- ls_pvalue
  
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
    start_time <- Sys.time()
    resSGBJ <-
      sGBJ::sGBJ(
        surv = survival::Surv(dfdata$time, dfdata$event),
        factor_matrix = dfdata %>% select(-time,-event) %>% as.matrix(),
        nperm = nperm_sGBJ
      )$sGBJ_pvalue
    end_time <- Sys.time()
    
    ls_pvalue$sGBJ <- resSGBJ
    ls_time$sGBJ <- as.numeric(end_time - start_time)
  }
  
  #Global boost test
  if("gbt" %in% methods){
    start_time <- Sys.time()
    gbst <-
      globalboosttest::globalboosttest(
        X = dfdata %>% select(-time,-event) %>% as.matrix(),
        Y = survival::Surv(dfdata$time, dfdata$event),
        Z = NULL,
        nperm = nb_permutation,
        mstop = 500,
        pvalueonly = TRUE
      )$pvalue[1]
    end_time <- Sys.time()
    
    ls_pvalue$`Global Boost Test` <- gbst
    ls_time$`Global Boost Test` <- as.numeric(end_time - start_time)
  }
  
  #Wald test
  if("wald" %in% methods){
    start_time <- Sys.time()
    wald_pval <- Wald_Test_Perm(vectime = dfdata$time,
                                vecevent = dfdata$event,
                                x = dfdata %>% select(-time,-event) %>% as.matrix(),
                                nb_permutation = nb_permutation)
    end_time <- Sys.time()
    
    ls_pvalue$`Wald Test` <- wald_pval
    ls_time$`Wald Test` <- as.numeric(end_time - start_time)
  }
  
  #Global Test
  if("gt" %in% methods){
    start_time <- Sys.time()
    survObj <- survival::Surv(dfdata$time,dfdata$event)
    ogt<-globaltest::gt(survObj,
                        x,
                        model="cox",
                        permutations = nb_permutation)
    gt_pval<-globaltest::p.value(ogt)
    end_time <- Sys.time()
    
    ls_pvalue$`Global Test` <- gt_pval
    ls_time$`Global Test` <- as.numeric(end_time - start_time)
  }
  
  #RF Test
  if("rf" %in% methods){
    start_time <- Sys.time()
    p_val_rf <- rfpermutation(dfdata = dfdata, nb_permutation = nb_permutation)
    end_time <- Sys.time()
    
    ls_pvalue$RF <- p_val_rf
    ls_time$RF <- as.numeric(end_time - start_time)
  }
  
  res <- data.frame(
    p_value = ls_pvalue %>% unlist(),
    time = ls_time %>% unlist(),
    method = names(ls_pvalue)
  ) %>%
    na.omit() %>%
    tibble::remove_rownames() %>%
    mutate(methods = paste0(methods, collapse = ", "),
           nb_observations = nb_observations,
           nb_genes = nb_genes,
           prop_sig_gene = prop_sig_gene,
           variance = variance,
           case = case,
           type = type,
           censoring = censoring,
           nb_permutation = nb_permutation,
           prop_two_periods = prop_two_periods,
           nperm_sGBJ = nperm_sGBJ,
           slam = slam)
  
  return(res)
}
