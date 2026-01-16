#' fct_generate_beta
#' 
#' @description Function to generate the beta coefficients
#'
#' @param type The scenario type either A, B or C
#' @param nb_genes The number of genes
#' @param prop_sig_gene The proportion of significant genes
#' @param corr_mat The correlation matrix of beta
#' @param return_mat_var_covar Boolean to return a list with beta and variance covariance matrix
#'
#' @return A vector of the beta coefficients
#' @export
#' 
fct_generate_beta <- function(type,
                              nb_genes,
                              prop_sig_gene,
                              corr_mat = NULL,
                              return_mat_var_covar = FALSE){
  
  nb_sig_gene = round(prop_sig_gene*nb_genes)
  
  if(type == "Z"){
    
    res <- rep(0, nb_genes)
    
  } else if(type == "A"){
    
    res <- c(rnorm(n = nb_sig_gene, mean = 0, sd = 0.5),
             rep(0, nb_genes-nb_sig_gene))
    
  } else if(type == "B"){
    
    res <- c(rnorm(n = ceiling(nb_sig_gene/2), mean = 0.1, sd = 0.5),
             rnorm(n = floor(nb_sig_gene/2), mean = -0.1, sd = 0.5),
             rep(0, nb_genes-nb_sig_gene))
    
  } else if(type == "C"){
    
    res <- c(rnorm(n = ceiling(nb_sig_gene/2), mean = 0.1, sd = 0.25),
             rnorm(n = floor(nb_sig_gene/2), mean = -0.1, sd = 1),
             rep(0, nb_genes-nb_sig_gene))
    
  } else if(type == "D"){
    
    res <- c(rnorm(n = nb_sig_gene, mean = 0, sd = 0.4),
             rep(0, nb_genes-nb_sig_gene))
    
  } else if(type == "E"){
    
    res <- c(rnorm(n = ceiling(nb_sig_gene/2), mean = -0.4, sd = 0.2),
             rnorm(n = floor(nb_sig_gene/2), mean = 0.4, sd = 0.2),
             rep(0, nb_genes-nb_sig_gene))
    
  } else if(type == "F"){
    
    res <- c(rnorm(n = ceiling(nb_sig_gene/2), mean = -0.8, sd = 0.4),
             rnorm(n = floor(nb_sig_gene/2), mean = 0.8, sd = 0.4),
             rep(0, nb_genes-nb_sig_gene))
    
  } else if(type %in% c("G", "H", "I")){
    
    if(type == "G"){
      vec_sd <- c(rep(0.4, nb_sig_gene),
                  rep(0, nb_genes-nb_sig_gene))
      vec_mu <- rep(0, nb_genes)
    } else if(type == "H"){
      vec_sd <- c(rep(0.4, nb_sig_gene),
                  rep(0, nb_genes-nb_sig_gene))
      vec_mu <- c(rep(-0.4, ceiling(nb_sig_gene/2)),
                  rep(0.4, floor(nb_sig_gene/2)),
                  rep(0, nb_genes-nb_sig_gene))
    } else if(type == "I"){
      vec_sd <- c(rep(0.4, nb_sig_gene),
                  rep(0, nb_genes-nb_sig_gene))
      vec_mu <- c(rep(-0.8, ceiling(nb_sig_gene/2)),
                  rep(0.8, floor(nb_sig_gene/2)),
                  rep(0, nb_genes-nb_sig_gene))
    }
    
    mat_var_covar <- diag(vec_sd) %*% corr_mat %*% diag(vec_sd)
    res <- mvtnorm::rmvnorm(n = 1,
                            mean = vec_mu,
                            sigma = mat_var_covar) |>
                            as.numeric()
    
  } else {
    stop("case must be between A and I")
  }
  
  if(return_mat_var_covar){
    return(list(beta = res,
                mat_var_covar = mat_var_covar))
  } else {
    return(res)
  }
}
