## package install
# BiocManager::install("globaltest")
# install.packages("coin")
# install.packages("mboost")
# install.packages("globalboosttest", repos = c("http://R-Forge.R-project.org"), dep = TRUE)

library(mvtnorm)
library(GBJ)
library(survival)
library(globaltest)
library(globalboosttest)
ite_base=as.numeric(Sys.getenv("SLURM_ARRAY_TASK_ID"))+999
# ite_base=1
ite=(ite_base%%48)+1

if (ite_base<=1920){
ns=50
}

if (ite_base>1920 & ite_base<=3840){
ns=80
}



params=read.table("data/simulations_table.txt",header=TRUE)
# params=read.table("data/simulations_table.txt",header=TRUE)[1:2,]
if (params[ite,1]==0.1){
gsp=0.3
}
if (params[ite,1]==0.3){
gsp=0.4
}

if (params[ite,1]==0.5){
gsp=0.5
}

cp=params[ite,3]
corr=params[ite,2]
#corr=4
beta=params[ite,4] #beta type: 1(positively) or 2(random)
#corr=1 #correlation type: 1(independence), 2(equal), 3(AR), 4(unstructured)
cenp=1 #censoring type: 1(no), 2(30%)
sigp=1 #significant gene proportion: 1(10%), 2(30%), 3(50%))
tau<-0.5 #correlation coefficient between genes
acp<-c(0.0,0.3) #censoring fraction
agsp<-c(0.1,0.3,0.5) #significant gene set proportion
nstat<-3 #test statistics of interest: GSEA with p=0,0.5,1, global test, and Adewale test
ng<-200 #gene size
#ns<-80 #sanple size
B<-1000 #permuation
# B<-2 #permuation
iter<-50 #iteration
# iter<-2 #iteration
gsize<-50 #gene set size
#gsp<-agsp[sigp]
ngs<-gsize*gsp
ncov<-ngs*(ngs-1)/2
ncov2<-ng*(ng-1)/2
p.pvalue<-matrix(0,nrow=nstat,ncol=iter)
ots<-matrix(0,nrow=nstat,ncol=iter)
p5<-rep(0,nstat)
cf<-rep(0,iter)

stats2=function(data,ng,gsize,nstat){
  time<-data[,1]
  csg<-data[,2]
  x<-data[,3:ncol(data)]
  wtcx<-matrix(0,nrow=2,ncol=ng)
  ucox<-rep(0,ng)
  escx0<-0
  escx1<-0
  gt<-0
  aw<-0
  bst<-0
  ts<-rep(0,nstat)
  for(i in 1:ng){
    ocx<-coxph(Surv(time,csg)~x[,i])
    ucox[i]<-ocx$coefficients/sqrt(ocx$var)
  }

  #global test
  ogt<-gt(Surv(time,csg),x[,1:gsize],model="cox")
  gt<-z.score(ogt)
  
  #Adewale test
  aw<-sum(ucox[1:gsize]^2)
  
  #Global boost test
  mstop<-500
  gbst<-globalboosttest(x[,1:gsize],Surv(time,csg),Z=NULL,nperm=1,mstop=mstop,pvalueonly=FALSE)
  bst<--gbst$riskreal[500]
  
  ts=c(gt,aw,bst)
  return(ts)
}

for(k in 1:iter){
  seed<-(beta*10^5+corr*10^4+cenp*10^3+sigp*10^2+k*20+ite_base*10)*100
  set.seed(seed)      
  if (beta==1) {
    bmean<-c(rep(0.1,floor(ngs/2)),rep(-0.5,(ngs-floor(ngs/2))),rep(0,ng-ngs)) #for power
    bsd<-c(rep(tau,floor(ngs/2)),rep(tau/2,(ngs-floor(ngs/2))),rep(0,ng-ngs)) #for power
  }else{
    bmean<-c(rep(0.1,floor(ngs/2)),rep(-0.1,(ngs-floor(ngs/2))),rep(0,ng-ngs)) #for power
    bsd<-c(rep(tau/2,floor(ngs/2)),rep(tau*2,(ngs-floor(ngs/2))),rep(0,ng-ngs)) #for power
  }
  xmean<-rep(0,ng)
  xsigma<-diag(rep(0.2,ng))
  # if (corr==1) {
  #   xgs<-diag(rep(0.2,ngs))        
  #   xgs[lower.tri(xgs==TRUE)]<-0.2*(rnorm(ncov,0,0.05))
  #   tmp<-xgs+t(xgs)-diag(diag(xgs))
  #   xsigma[1:ngs,1:ngs]<-tmp
  # }

  if (corr==2) {
    xgs<-diag(rep(0.2,ngs))        
    xgs[lower.tri(xgs==TRUE)]<-0.4*(rnorm(ncov,0.4,0.1))
    tmp<-xgs+t(xgs)-diag(diag(xgs))
    xsigma[1:ngs,1:ngs]<-tmp
  }
  if (corr==3) {
    xgs<-diag(rep(0.2,ngs))        
    xgs[lower.tri(xgs==TRUE)]<-0.4*sample(c(-1,1), size = 1, prob = c(1/2,  1/2),replace = TRUE)*(rnorm(ncov,0.4,0.1))
    tmp<-xgs+t(xgs)-diag(diag(xgs))
    xsigma[1:ngs,1:ngs]<-tmp
  }
  if (corr==4) {
    xgs<-diag(rep(0.2,ng))        
    xgs[lower.tri(xgs==TRUE)]<-0.4*(rnorm(ncov2,0,0.01))
    tmp<-xgs+t(xgs)-diag(diag(xgs))
    xsigma[1:ng,1:ng]<-tmp
  }       
  x<-rmvnorm(n=ns,mean=xmean,sigma=xsigma,method="chol")
  colnames(x)<-paste("G",1:ng,sep="")
  tbeta<-rnorm(ng,mean=bmean,sd=bsd)
  predictor<-x%*%tbeta
  randu<-runif(ns,min=0,max=1)
  dim(randu)<-c(ns,1)
  slam=0.005
  time<-exp(-predictor)*(-log(1-randu))/slam
  if (cp==0) {
    otime<-time
    csgind<-rep(1,ns)
  }else{
    clam<-exp(predictor)*slam*cp/(1-cp)
    csg<-rexp(ns,rate=clam)
    dim(csg)<-c(ns,1)
    csgind<-(time<=csg)
    otime<-time*csgind+csg*(1-csgind)
  }
  cf[k]<-mean(1-csgind)
  odata<-data.frame(cbind(otime,csgind,x))
  ots<-stats2(odata,ng,gsize,nstat)
  rts<-matrix(0,nrow=nstat,ncol=B)
  for(b in 1:B){
    print(b)
    seed2<-(beta*10^5+corr*10^4+cenp*10^3+sigp*10^2+b*20+ite_base*10)*100
    
    set.seed(seed2)
    permute<-sample(1:ns)
    rtime<-otime[permute]
    rcsgind<-csgind[permute]
    rdata<-data.frame(cbind(rtime,rcsgind,x))
    rts[,b]<-stats2(rdata,ng,gsize,nstat)
  }
  p.pvalue<-apply((rts>ots),1,mean)
  
  test=x[,1:gsize]
  counts_pathway=x[,1:gsize]
  T_s=otime
  event=csgind
  remove_Z=NULL
  Z=numeric((dim(test)[2]))
  for (i in 1:(dim(test)[2])){
    surv=Surv(T_s,event)
    model=try(coxph(surv~counts_pathway[,i], data = as.data.frame(counts_pathway)))
    if (length(model)==19){
if(length(sqrt(model$wald.test))==0){
             remove_Z=c(remove_Z,i)

          }else{
      Z[i]=sqrt(model$wald.test)
      if (is.na(Z[i])){
        remove_Z=c(remove_Z,i)
      }
      if (abs(Z[i])==Inf){
        remove_Z=c(remove_Z,i)
        
      }
    }}else{
      remove_Z=c(remove_Z,i)
      
    }
  }
  if (length(remove_Z)!=0){
    Z=Z[-remove_Z]
    print(remove_Z)
  }
  
  Z_matrix<- matrix(nrow=(length(Z)), ncol=200)
  Z_matrix[,1]=Z
  i=2
  while(i<=200){
    print(i)
    surv_perm=surv[sample(length(surv))]
    perm_OK=TRUE
    for (j in 1:(length(Z))){
      model=try(coxph(surv_perm~counts_pathway[,j], data = as.data.frame(counts_pathway)))
      if (length(model)==19){
	if(length(sqrt(model$wald.test))==0){
            perm_OK=FALSE
          }else{
        Z_matrix[j,i]=sqrt(model$wald.test)
        if( is.na(Z_matrix[j,i])){
          print(c("Z matrix na",i,j))
          print(c("coeffs",model$coefficients,sqrt(model$var)))
          perm_OK=FALSE
        }
        if ((abs(Z_matrix[j,i])==Inf)|(is.na(Z_matrix[j,i]))){
          perm_OK=FALSE
        }
        
        
      }}else{perm_OK=FALSE}
      
    }
    if (perm_OK==TRUE){
      i=i+1
    }
  }
  
  epsilon=cor(t(Z_matrix))
  scores_GBJ=list(test_stats=Z,cor_mat=epsilon)
  GBJOut <- GBJ(test_stats=Z, cor_mat=epsilon)
  cat(paste("beta=",beta,"correlation=",corr,"cenp=",cenp,"sigp=",sigp,"iter=",k),sep="\n")
  results=rbind(c(k,beta,corr,cp,gsp,ns,p.pvalue[1],p.pvalue[2],p.pvalue[3],GBJOut$GBJ_pvalue),c(k,beta,corr,cp,gsp,ns,p.pvalue[1],p.pvalue[2],p.pvalue[3],GBJOut$GBJ_pvalue))
  write.table(results,paste("results/comparaison_survival_sets_bis_corr_beta6_bis_2000.txt",sep=""),row.names = FALSE,col.names = FALSE,append = TRUE)
  
  }
