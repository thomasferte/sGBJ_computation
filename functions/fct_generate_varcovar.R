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
  corr_mat <- NULL
  
  nb_sig_gene = round(prop_sig_gene * nb_genes)
  
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
    variances <- rep(variance, nb_genes)
    
    corr_mat <- fct_impute_nsbeta(nb_genes = nb_genes,
                                  shape1 = 20,
                                  shape2 = 20)
    
    if(!matrixcalc::is.positive.definite(corr_mat)){
      corr_mat <- Matrix::nearPD(corr_mat, corr = TRUE, base.matrix = TRUE)$mat
    }
    
    # Compute the covariance matrix
    mat_var_covar <- diag(sqrt(variances)) %*% corr_mat %*% diag(sqrt(variances))
    
  } else if(case == 5){
    variances <- rep(variance, nb_genes)
    
    corr_mat <- fct_impute_nsbeta(nb_genes = nb_genes,
                                  shape1 = 25,
                                  shape2 = 25)
    
    corr_mat_sig <- fct_impute_nsbeta(nb_genes = nb_sig_gene,
                                      shape1 = 10,
                                      shape2 = 10)
    
    corr_mat[1:nrow(corr_mat_sig), 1:ncol(corr_mat_sig)] <- corr_mat_sig
    
    if(!matrixcalc::is.positive.definite(corr_mat)){
      corr_mat <- Matrix::nearPD(corr_mat, corr = TRUE, base.matrix = TRUE)$mat
    }
    
    # Compute the covariance matrix
    mat_var_covar <- diag(sqrt(variances)) %*% corr_mat %*% diag(sqrt(variances))
    
  } else if(case == 6){
    
    ls_cor <- fct_correlation_matrix_simple(nb_genes = nb_genes,
                                            nb_sig_gene = nb_sig_gene,
                                            variance = variance,
                                            correlation_value_sig = 0.2,
                                            correlation_value_non_sig = 0)
    mat_var_covar <- ls_cor$mat_var_covar
    corr_mat <- ls_cor$corr_mat
    
  } else {
    stop("case must be between 1 and 7")
  }
  
  # set the variance
  diag(mat_var_covar) <- variance
  
  if(!isSymmetric(mat_var_covar)) stop("Covariance matrix is not symetric")
  if(det(mat_var_covar) <= 0) stop("Covariance matrix is not definite")
  
  return(list(mat_var_covar = mat_var_covar,
              corr_mat = corr_mat))
}

#' fct_impute_nsbeta
#' 
#' @description Build a correlation matrix with nsbeta law
#'
#' @param nb_genes The number of genes
#' @param shape1 Argument passed to rnsbeta
#' @param shape2 Argument passed to rnsbeta
#'
#' @return A correlation matrix
#' @export
#' 
fct_impute_nsbeta <- function(nb_genes,
                              shape1,
                              shape2){
  # Correlation matrix
  correlation <- matrix(data = 0, nrow = nb_genes, ncol = nb_genes)
  bool_lower_tri <- lower.tri(correlation)
  bool_upper_tri <- upper.tri(correlation)
  
  # correlation on all genes
  vec_correlation <- extraDistr::rnsbeta(n = sum(bool_lower_tri),
                                         shape1 = shape1, shape2 = shape2,
                                         min = -1, max = 1)
  correlation[bool_lower_tri] <- vec_correlation
  correlation[bool_upper_tri] <- t(correlation)[bool_upper_tri]
  
  diag(correlation) <- 1
  
  return(correlation)
}

#' fct_impute_simple_correlation
#' 
#' @description Build a correlation matrix with nsbeta law
#'
#' @param nb_genes The number of genes
#' @param correlation_value Correlation value
#'
#' @return A correlation matrix
#' @export
#' 
fct_impute_simple_correlation <- function(nb_genes,
                                          correlation_value){
  
  # Correlation matrix
  correlation <- matrix(data = correlation_value, nrow = nb_genes, ncol = nb_genes)
  diag(correlation) <- 1
  
  return(correlation)
}

#' fct_correlation_matrix_simple
#' 
#' @description Build a correlation matrix with nsbeta law
#'
#' @param nb_genes The number of genes
#' @param nb_sig_gene The number of genes
#' @param correlation_value_non_sig Correlation value
#' @param correlation_value_sig Correlation value
#'
#' @return A list with correlation and variance covariance matrix
#' @export
#' 
fct_correlation_matrix_simple <- function(nb_genes,
                                          nb_sig_gene,
                                          variance,
                                          correlation_value_sig,
                                          correlation_value_non_sig){
  
  variances <- rep(variance, nb_genes)
  corr_mat <- fct_impute_simple_correlation(nb_genes = nb_genes,
                                            correlation_value = correlation_value_non_sig)
  corr_mat_sig <- fct_impute_simple_correlation(nb_genes = nb_sig_gene,
                                                correlation_value = correlation_value_sig)
  corr_mat[1:nrow(corr_mat_sig), 1:ncol(corr_mat_sig)] <- corr_mat_sig
  
  # Compute the covariance matrix
  mat_var_covar <- diag(sqrt(variances)) %*% corr_mat %*% diag(sqrt(variances))
  
  return(list(mat_var_covar = mat_var_covar,
              corr_mat = corr_mat))
}
