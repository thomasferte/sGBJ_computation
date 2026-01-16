#' Frobenius_sGBJ
#'
#' @param case The case scenario
#' @param prop_sig_gene The proportion of significant genes
#' @param nb_genes The number of genes
#' @param nb_observations The number of observations
#' @param variance The variance
#' @param type The type scenario
#' @param nperm_sGBJ The number of sGBJ permutation
#' @param slam The slam (survival generation)
#' @param prop_two_periods If there should be generation of non proportional HR
#' @param censoring Proportion of censoring
#'
#' @returns The Frobenius distance between sGBJ and true matrix of var covar of beta
Frobenius_sGBJ <- function(case = 5,
                           prop_sig_gene = 0.2,
                           nb_genes = 50,
                           nb_observations = 100,
                           variance = 0.2,
                           type = "H",
                           nperm_sGBJ = 10,
                           slam = 0.005,
                           prop_two_periods = FALSE,
                           censoring = 0.3){
  
  ##### generate data
  mat_var_covar <- fct_generate_varcovar(case = case,
                                         prop_sig_gene = prop_sig_gene,
                                         nb_genes = nb_genes,
                                         variance = variance)
  
  ls_beta <- fct_generate_beta(type = type,
                               prop_sig_gene = prop_sig_gene,
                               nb_genes = nb_genes,
                               corr_mat = mat_var_covar$corr_mat,
                               return_mat_var_covar = TRUE)
  
  vec_beta <- ls_beta$beta
  true_var_covar_beta <- ls_beta$mat_var_covar
  
  ### generate genes values
  x<-mvtnorm::rmvnorm(n=nb_observations,
                      mean=rep(0,nb_genes),
                      sigma=mat_var_covar$mat_var_covar)
  colnames(x) <- paste0("gene", 1:ncol(x))
  
  ### generate survival time
  dfsurvival <- fct_generate_survival_data(censoring = censoring,
                                           vec_beta = vec_beta,
                                           prop_two_periods = prop_two_periods,
                                           slam = slam,
                                           x = x)
  ##### SGBJ
  sGBJ_scores <- sGBJ::sGBJ_scores(surv = survival::Surv(dfsurvival$time, dfsurvival$event),
                                   factor_matrix = dfsurvival %>% select(-time,-event) %>% as.matrix(),
                                   nperm = nperm_sGBJ)
  sGBJ_var_covar_beta <- sGBJ_scores$cor_mat
  
  ##### Frobenius distance
  Frobenius_distance <- StatPerMeCo::Frobenius(S = true_var_covar_beta, H = sGBJ_var_covar_beta)
  
  return(Frobenius_distance)
}

