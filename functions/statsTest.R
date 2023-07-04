#' statsTest
#'
#' @description Function which compute test statistics for Global Boost test, Wald test and Global Test
#'
#' @param vectime the time
#' @param vecevent the event
#' @param x the genes experession
#'
#' @return A vector with the statistical test of global test, adewale test
#' @export
#'
statsTest=function(vectime, vecevent, x){
  ng <- ncol(x)
  ucox<-rep(0,ng)
  
  survObj <- survival::Surv(vectime,vecevent)
  
  for(i in 1:ng){
    ocx<-survival::coxph(survObj~x[,i])
    ucox[i]<-ocx$coefficients/sqrt(ocx$var)
  }
  
  #global test
  ogt<-globaltest::gt(survObj,
                      x,
                      model="cox")
  gt<-globaltest::z.score(ogt)
  
  #Adewale test
  aw<-sum(ucox^2)
  
  ts=c(gt,aw)
  return(ts)
}



#' pre_Wald_Test
#'
#' @description Function used for wald test computation
#'
#' @param vectime the time
#' @param vecevent the event
#' @param x the genes experession
#'
#' @return A vector with the statistical test of global test, adewale test
#' @export
#'
pre_Wald_Test=function(vectime, vecevent, x){
  # baseline
  survObj <- survival::Surv(vectime,vecevent)
  ucox <- lapply(X = 1:ncol(x),
         FUN = function(x){
           ocx<-survival::coxph(survObj~x[,i])
           res<-ocx$coefficients/sqrt(ocx$var)
           return(res)
         }) %>%
    unlist()
  
  res <- sum(ucox^2)
  
  return(res)
}

#' Wald_Test_Perm
#'
#' @description Function which compute Wald test
#'
#' @param vectime the time
#' @param vecevent the event
#' @param x the genes experession
#' @param nb_permutation Number of permutation
#'
#' @return A vector with the statistical test of global test, adewale test
#' @export
#'
Wald_Test_Perm=function(vectime, vecevent, x, nb_permutation){
  # baseline
  baseline_ucox <- pre_Wald_Test(vectime = vectime,
                                 vecevent = vecevent,
                                 x = x)
  
  # permutation
  permut_ucox <- lapply(X = 1:nb_permutation,
                        FUN = function(b){
                          id_sample <- sample(1:length(vectime), replace = FALSE)
                          vectime_perm <- vectime[id_sample]
                          vecevent_perm <- vecevent[id_sample]
                          
                          res <- pre_Wald_Test(vectime = vectime_perm,
                                               vecevent = vecevent_perm,
                                               x = x)
                          return(res)
                        })
    
  res <- mean(permut_ucox > baseline_ucox)
  
  return(res)
}


