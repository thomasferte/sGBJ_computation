#' statsTest
#'
#' @description Function which compute test statistics for Global Boost test, Wald test and Global Test
#'
#' @param time the time
#' @param event the event
#' @param x the genes experession
#'
#' @return A vector with the statistical test of global test, adewale test and global boost test
#' @export
#'
statsTest=function(time, event, x){
  ng <- ncol(x)
  wtcx<-matrix(0,nrow=2,ncol=ng)
  ucox<-rep(0,ng)
  escx0<-0
  escx1<-0
  gt<-0
  aw<-0
  bst<-0
  
  for(i in 1:ng){
    ocx<-coxph(Surv(time,event)~x[,i])
    ucox[i]<-ocx$coefficients/sqrt(ocx$var)
  }
  
  #global test
  ogt<-gt(Surv(time,event),x[,1:gsize],model="cox")
  gt<-z.score(ogt)
  
  #Adewale test
  aw<-sum(ucox[1:gsize]^2)
  
  #Global boost test
  mstop<-500
  gbst<-globalboosttest(x[,1:gsize],Surv(time,event),Z=NULL,nperm=1,mstop=mstop,pvalueonly=FALSE)
  bst<--gbst$riskreal[500]
  
  ts=c(gt,aw,bst)
  return(ts)
}
