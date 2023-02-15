#' statsTest
#'
#' @description Function which compute test statistics for Global Boost test, Wald test and Global Test
#'
#' @param vectime the time
#' @param vecevent the event
#' @param x the genes experession
#'
#' @return A vector with the statistical test of global test, adewale test and global boost test
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
  
  #Global boost test
  mstop<-500
  gbst<-globalboosttest::globalboosttest(x,
                                         survObj,
                                         Z=NULL,
                                         nperm=1,
                                         mstop=mstop,
                                         pvalueonly=FALSE)
  bst<--gbst$riskreal[500]
  
  ts=c(gt,aw,bst)
  return(ts)
}
