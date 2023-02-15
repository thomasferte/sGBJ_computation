#' fct_generate_data
#' 
#' @description Function used to generate the data
#'
#' @param case The scenario case
#' @param variance The variance of genes
#' @param type The type of beta
#' @param prop_sig_gene the proportion of significant genes
#' @param nb_genes The number of genes
#' @param censoring The proportion of censoring
#' @param vec_beta The vector of beta
#' @param x The gene set
#'
#' @return A dataframe with time, event and genes
#' @export
fct_generate_data <- function(case,
                              variance,
                              type,
                              prop_sig_gene,
                              nb_genes,
                              censoring,
                              vec_beta,
                              x){
  mat_var_covar <- fct_generate_varcovar(case = case,
                                         prop_sig_gene = prop_sig_gene,
                                         nb_genes = nb_genes,
                                         variance = variance)
  
  vec_beta <- fct_generate_beta(type = type,
                                prop_sig_gene = prop_sig_gene,
                                nb_genes = nb_genes)
  
  ### generate genes values
  x<-mvtnorm::rmvnorm(n=nb_observations,
                      mean=rep(0,nb_genes),
                      sigma=mat_var_covar,
                      method="chol")
  colnames(x) <- paste0("gene", 1:ncol(x))
  
  ### generate survival time
  dfsurvival <- fct_generate_survival_data(censoring = censoring,
                                           vec_beta = vec_beta,
                                           x = x)
  
  return(dfsurvival)
}
