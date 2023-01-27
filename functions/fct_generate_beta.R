#' fct_generate_beta
#' 
#' @description Function to generate the beta coefficients
#'
#' @param type The scenario type either A, B or C
#' @param nb_genes The number of genes
#' @param prop_sig_gene The proportion of significant genes
#'
#' @return A vector of the beta coefficients
#' @export
#' 
fct_generate_beta <- function(type,
                              nb_genes,
                              prop_sig_gene){
  
  nb_sig_gene = prop_sig_gene*nb_genes
  
  if(type == "A"){
    
    res <- c(rnorm(n = nb_sig_gene, mean = 0, sd = 0.5),
             rep(0, nb_genes-nb_sig_gene))
    
  } else if(type == "B"){
    
    res <- c(rnorm(n = nb_sig_gene/2, mean = 0.1, sd = 0.5),
             rnorm(n = nb_sig_gene/2, mean = -0.1, sd = 0.5),
             rep(0, nb_genes-nb_sig_gene))
    
  } else if(type == "C"){
    
    res <- c(rnorm(n = nb_sig_gene/2, mean = 0.1, sd = 0.25),
             rnorm(n = nb_sig_gene/2, mean = -0.1, sd = 1),
             rep(0, nb_genes-nb_sig_gene))
    
  } else {
    stop("case must be A, B or C")
  }
  
  return(res)
  
}