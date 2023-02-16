#' fct_generate_survival_data
#' 
#' @description function to generate survival data
#'
#' @param censoring censoring proportion
#' @param vec_beta vector of beta for cox model
#' @param prop_two_periods Should the beta be divided by 2 after a given period (not respect proportionality assumption)
#' @param slam A constant used in the exponential simulation (default = 0.005)
#' @param x the gene set
#'
#' @return A dataframe with survival time, event and gene set
#' @export
#' 
fct_generate_survival_data <- function(censoring,
                                       vec_beta,
                                       prop_two_periods = FALSE,
                                       slam = 0.005,
                                       x){
  
  # survival time
  predictor<-x%*%vec_beta
  time <- simu_simple_beta(x = x, predictor = predictor, slam=slam)
  if(prop_two_periods){
    time_shift = quantile(time, 0.25)
    time <- simu_twoperiod_beta(x = x, predictor = predictor, slam=slam, time_shift = time_shift)
  }
  
  # censoring
  if (censoring==0) {
    df_survival <- data.frame(time = time,
                              event = 1)
  }else{
    clam<-exp(predictor)*slam*censoring/(1-censoring)
    csg<-rexp(length(vec_beta),rate=clam)
    dim(csg)<-c(length(vec_beta),1)
    csgind<-(time<=csg)
    otime<-time*csgind+csg*(1-csgind)
    
    df_survival <- data.frame(time = otime,
                              event = as.numeric(csgind))
  }
  
  res <- cbind(df_survival, x)
  
  return(res)
}
