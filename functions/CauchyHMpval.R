# toy <- survival::veteran
# 
# vectime = toy$time
# vecevent = toy$status
# covariates = as.matrix(toy[,c("age", "prior")])
# x = as.matrix(toy[,c("celltype", "karno", "diagtime")])

CauchyHMpval <- function(vectime,
                         vecevent,
                         covariates = NULL,
                         type = "Cauchy",
                         x){
  survObj <- survival::Surv(vectime,vecevent)
  if(is.null(covariates)){
    vec_pval <- lapply(X = 1:ncol(x),
                       FUN = function(i){
                         ocx<-survival::coxph(survObj~x[,i])
                         ocxempty<-survival::coxph(survObj~1)
                         pval <- anova(ocx,ocxempty)$`Pr(>|Chi|)`[2]
                         return(pval)
                       }) %>%
      unlist()
  } else {
    vec_pval <- lapply(X = 1:ncol(x),
                       FUN = function(i){
                         df_combined <- covariates |> bind_cols(as.data.frame(x[,i]))
                         ocx<-survival::coxph(survObj~., data = df_combined)
                         ocxempty<-survival::coxph(survObj~., data = as.data.frame(covariates))
                         pval <- anova(ocx,ocxempty)$`Pr(>|Chi|)`[2]
                         return(pval)
                       }) %>%
      unlist()
  }
  
  if(type == "Cauchy"){
    # ACAT: Aggregated Cauchy Association Test
    res <- ICSKAT::ACAT(vec_pval)
  }
  
  if(type == "HM"){
    # Harmonic mean test
    res <- as.numeric(harmonicmeanp::hmp.stat(vec_pval))
  }
  
  return(res)
}