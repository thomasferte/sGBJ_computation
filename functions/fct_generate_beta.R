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
  
  nb_sig_gene = round(prop_sig_gene*nb_genes)
  
  if(type == "A"){
    
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
    
  } else {
    stop("case must be between A and F")
  }
  
  return(res)
  
}