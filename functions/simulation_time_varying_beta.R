#' simu_simple_beta
#'
#' @description A function to simulate simple exponential survival function depending on beta
#'
#' @param slam A constant used in the exponential simulation (default = 0.005)
#' @param x Matrix of genes
#' @param predictor predictor
#'
#' @return A vector of failure time
simu_simple_beta <- function(predictor,
                             slam = 0.005,
                             x){
  nb_observations <- nrow(x)
  randu<-runif(nb_observations,min=0,max=1)
  dim(randu)<-c(nb_observations,1)
  time<-exp(-predictor)*(-log(1-randu))/slam
  return(time)
}

#################################################
##### simu two times effect #####################
#################################################


#' simu_twoperiod_beta
#'
#' @description A function to simulate simple exponential survival function depending on beta. After time_shift period, beta is divided by two.
#'
#' @param slam A constant used in the exponential simulation
#' @param x Matrix of genes
#' @param time_shift Time point after which beta is divided by 2
#' @param predictor predictor
#'
#' @return A vector of failure time
simu_twoperiod_beta <- function(predictor,
                                slam = 0.005,
                                x,
                                time_shift){
  time1 <- simu_simple_beta(predictor = predictor,
                            slam = slam,
                            x = x)
  
  time2 <- simu_simple_beta(predictor = predictor,
                            slam = slam,
                            x = x)
  
  time <- ifelse(time1 > time_shift,
                 yes = time_shift + time2,
                 no = time1)
  return(time)
}
