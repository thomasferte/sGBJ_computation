#' fct_generate_survival_data
#' 
#' @description function to generate survival data
#'
#' @param censoring censoring proportion
#' @param vec_beta vector of beta for cox model
#' @param x the gene set
#'
#' @return A dataframe with survival time, event and gene set
#' @export
#' 
fct_generate_survival_data <- function(censoring,
                                       vec_beta,
                                       x){
  
  # survival time
  predictor<-x%*%vec_beta
  randu<-runif(nb_observations,min=0,max=1)
  dim(randu)<-c(nb_observations,1)
  slam=0.005
  time<-exp(-predictor)*(-log(1-randu))/slam
  
  # censoring
  if (cp==0) {
    df_survival <- data.frame(time = time,
                              event = 1)
  }else{
    clam<-exp(predictor)*slam*cp/(1-cp)
    csg<-rexp(ns,rate=clam)
    dim(csg)<-c(ns,1)
    csgind<-(time<=csg)
    otime<-time*csgind+csg*(1-csgind)
    
    df_survival <- data.frame(time = otime,
                              event = as.numeric(csgind))
  }
  
  res <- dplyr::bind_cols(df_survival, x)
  
  return(res)
}
