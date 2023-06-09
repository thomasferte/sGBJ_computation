#' fct_generate_varcovar
#' 
#' @description Generate a variance covariance matrix.
#'
#' @param case Simulation case must be 1, 2 or 3
#' @param prop_sig_gene The proportion of significant gene (only used in case 2). If this argument is provided, the significant genes are the first prop_sig_gene*nb_genes genes.
#' @param nb_genes The number of genes
#' @param variance The variance (diagonal of the matrix)
#'
#' @return A variance covariance matrix
#' @export
#' 
fct_generate_varcovar <- function(case,
                                  prop_sig_gene,
                                  nb_genes,
                                  variance){
  nb_sig_gene = prop_sig_gene * nb_genes
  
  if(case == 1){
    
    mat_var_covar <- matrix(data = 0, nrow = nb_genes, ncol = nb_genes)
    
  } else if(case == 2){
    # varcovar for non significant genes
    mat_var_covar <- matrix(data = 0, nrow = nb_genes, ncol = nb_genes)
    
    # covar for significant genes
    covar <- 0.4*rnorm(n = nb_sig_gene^2/2-nb_sig_gene/2,
                       mean = 0.4,
                       sd = 0.1)
    
    # fill upper triangle
    mat_var_covar[1:nb_sig_gene,1:nb_sig_gene][upper.tri(mat_var_covar[1:nb_sig_gene,1:nb_sig_gene])] <- covar
    # duplicate to lower triangle
    mat_var_covar[lower.tri(mat_var_covar)] <- t(mat_var_covar)[lower.tri(mat_var_covar)]
    
  } else if(case == 3){
    # varcovar for significant genes
    covar <- 0.4*rnorm(n = nb_genes^2,
                       mean = 0,
                       sd = 0.01)
    mat_var_covar <- matrix(data = covar,
                            nrow = nb_genes,
                            ncol = nb_genes)
    # duplicate upper triangle to lower triangle
    mat_var_covar[lower.tri(mat_var_covar)] <- t(mat_var_covar)[lower.tri(mat_var_covar)]
    
  } else if(case == 4){
    # Vector of variances
    variances <- rep(0.2, nb_genes)
    
    # Correlation matrix
    correlation <- matrix(data = 0, nrow = nb_genes, ncol = nb_genes)
    
    # correlation on significant genes
    correlation_sig <- correlation[1:nb_sig_gene, 1:nb_sig_gene]
    bool_lower_tri <- lower.tri(correlation_sig)
    bool_upper_tri <- upper.tri(correlation_sig)
    vec_correlation <- runif(sum(bool_lower_tri), min = 0, max = 1)
    correlation_sig[bool_lower_tri] <- vec_correlation
    correlation_sig[bool_upper_tri] <- t(correlation_sig)[bool_upper_tri]
    
    correlation[1:nb_sig_gene, 1:nb_sig_gene] <- correlation_sig
    diag(correlation) <- 1
    
    # Compute the covariance matrix
    covariance <- diag(sqrt(variances)) %*% correlation %*% diag(sqrt(variances))
    
    if(!isSymmetric(covariance)) stop("Covariance matrix is not symetric")
    
  } else {
    stop("case must be 1, 2 or 3")
  }
  
  # set the variance
  diag(mat_var_covar) <- variance
  
  return(mat_var_covar)
}