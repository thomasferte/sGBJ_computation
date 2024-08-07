Discordance LV - TF
================
TF
2024-08-07

- <a href="#1-plots" id="toc-1-plots">1 Plots</a>
  - <a href="#11-draft-plot" id="toc-11-draft-plot">1.1 Draft plot</a>
- <a href="#2-new-plot-fails-to-replicate"
  id="toc-2-new-plot-fails-to-replicate">2 New plot (fails to
  replicate)</a>
- <a href="#3-data-generation" id="toc-3-data-generation">3 Data
  generation</a>
  - <a href="#31-variance-covariance" id="toc-31-variance-covariance">3.1
    Variance covariance</a>
    - <a href="#311-tf" id="toc-311-tf">3.1.1 TF</a>
    - <a href="#312-lv" id="toc-312-lv">3.1.2 LV</a>
    - <a href="#313-comparison" id="toc-313-comparison">3.1.3 Comparison</a>
  - <a href="#32-beta" id="toc-32-beta">3.2 Beta</a>
    - <a href="#321-tf" id="toc-321-tf">3.2.1 TF</a>
    - <a href="#322-lv" id="toc-322-lv">3.2.2 LV</a>
    - <a href="#323-comparison" id="toc-323-comparison">3.2.3 Comparison</a>
  - <a href="#33-survival" id="toc-33-survival">3.3 Survival</a>
    - <a href="#331-tf" id="toc-331-tf">3.3.1 TF</a>
    - <a href="#332-lv" id="toc-332-lv">3.3.2 LV</a>
    - <a href="#333-comparison" id="toc-333-comparison">3.3.3 Comparison</a>

# 1 Plots

## 1.1 Draft plot

<div class="figure">

<img src="../images/comparison_methods6-1.png" alt="Original plot" width="977" />

<p class="caption">

Figure 1.1: Original plot

</p>

</div>

# 2 New plot (fails to replicate)

<div class="figure">

<img src="../images/plot_original.png" alt="New plot (fails to replicate)" width="1102" />

<p class="caption">

Figure 2.1: New plot (fails to replicate)

</p>

</div>

# 3 Data generation

## 3.1 Variance covariance

### 3.1.1 TF

``` r
if(case == 1){
  
  mat_var_covar <- matrix(data = 0, nrow = nb_genes, ncol = nb_genes)
  
} else if(case == 2){
  # varcovar for non significant genes
  mat_var_covar <- matrix(data = 0, nrow = nb_genes, ncol = nb_genes)
  
  # covar for significant genes
  nb_sig_gene = prop_sig_gene * nb_genes
  
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
  
} else {
  stop("case must be 1, 2 or 3")
}

# set the variance
diag(mat_var_covar) <- variance

return(mat_var_covar)
```

### 3.1.2 LV

``` r
xsigma<-diag(rep(0.2,ng)) # The variance corresponding to Cjj ?

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
```

### 3.1.3 Comparison

- Diagonal variance is 0.2 in both
- Covariance corr is not 2,3,4 in LV is similar to case == 1 in TF
- corr == 2 in LV is similar to case == 2 in TF
- corr == 4 in LV is similar to case == 3 in TF

## 3.2 Beta

### 3.2.1 TF

``` r
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
  
} else {
  stop("case must be A, B or C")
}

return(res)
```

### 3.2.2 LV

``` r
if (params[ite,1]==0.1){
  gsp=0.3
}
if (params[ite,1]==0.3){
  gsp=0.4
}

if (params[ite,1]==0.5){
  gsp=0.5
}
gsize<-50 #gene set size
#gsp<-agsp[sigp]
ngs<-gsize*gsp
tau <- 0.5

if (beta==1) {
  bmean<-c(rep(0.1,floor(ngs/2)),
           rep(-0.5,(ngs-floor(ngs/2))),
           rep(0,ng-ngs)) #for power
  bsd<-c(rep(tau,floor(ngs/2)),
         rep(tau/2,(ngs-floor(ngs/2))),
         rep(0,ng-ngs)) #for power
}else{
  bmean<-c(rep(0.1,floor(ngs/2)),
           rep(-0.1,(ngs-floor(ngs/2))),
           rep(0,ng-ngs)) #for power
  bsd<-c(rep(tau/2,floor(ngs/2)),
         rep(tau*2,(ngs-floor(ngs/2))),
         rep(0,ng-ngs)) #for power
}

tbeta<-rnorm(ng,mean=bmean,sd=bsd)
```

### 3.2.3 Comparison

- Nothing corresponds to case == ‘A’ in LV script
- There is no scenario in the paper where beta follows gaussian
  distribution with mean -0.5 (beta == 1 in LV script)
- The variance defined in LV when beta != 1 corresponds to type == “C”
  in TF (because tau = 0.5)
- The proportion of significant gene does not match the ones in the
  paper

## 3.3 Survival

### 3.3.1 TF

``` r
predictor<-x%*%vec_beta
time <- simu_simple_beta(x = x, predictor = predictor, slam=slam)

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

simu_simple_beta <- function(predictor,
                             slam = 0.005,
                             x){
  nb_observations <- nrow(x)
  randu<-runif(nb_observations,min=0,max=1)
  dim(randu)<-c(nb_observations,1)
  time<-exp(-predictor)*(-log(1-randu))/slam
  return(time)
}
```

### 3.3.2 LV

``` r
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
```

### 3.3.3 Comparison

Same implementation
