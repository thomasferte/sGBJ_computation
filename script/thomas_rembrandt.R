library(dplyr)
library(survival)

##### load data
pathways = GSA::GSA.read.gmt("data/rembrandt/c6.all.v7.1.symbols.gmt")
datas_tot = readRDS("data/rembrandt/dfGenesAndClinical.rds")

##### data cleaning
liste_pathways=pathways$genesets
liste_names=pathways$geneset.names
names(liste_pathways) <- liste_names

datas_clean <- datas_tot %>%
  select(-c("BIOSPECIMEN_ID")) %>%
  filter(DISEASE_TYPE %in% c("ASTROCYTOMA","GBM","OLIGODENDROGLIOMA"))

##### test 1 pathway

extract_varcovar <- function(pathway_i){
  cox_model <- datas_clean %>%
    select(EVENT_OS, OVERALL_SURVIVAL_MONTHS, any_of(pathway_i)) %>%
    coxph(Surv(OVERALL_SURVIVAL_MONTHS, EVENT_OS) ~ .,
          data = .)
  
  vcov_path <- cox_model %>%
    vcov()
  
  pval_path <- summary(cox_model)$coefficients[,"Pr(>|z|)"]
  
  sign_genes <- names(pval_path)[pval_path<0.05]
  nosign_genes <- names(pval_path)[!pval_path<0.05]
  all_genes <- names(pval_path)
  
  
  ## get variance and covariance
  dfres <- lapply(list(sign = sign_genes,
                       nosign = nosign_genes,
                       all = all_genes),
                  FUN = function(x){
                    vcov_path_select <- vcov_path[rownames(vcov_path) %in% x, colnames(vcov_path) %in% x]
                    vec_variance <- diag(vcov_path_select)
                    diag(vcov_path_select) <- 0
                    vec_covariance <- vcov_path_select[lower.tri(vcov_path_select)]
                    
                    lsres <- lapply(list(var = vec_variance,
                                         covar = vec_covariance),
                                    FUN = function(x) return(data.frame(mean = mean(x),
                                                                        var = var(x)))) %>%
                      bind_rows(.id = "param")
                    
                    return(lsres)
                    
                  }) %>%
    bind_rows(.id = "signif")
  
  return(dfres)
}

dfresvarcovar <- pbapply::pblapply(liste_pathways,
                                   FUN = extract_varcovar) %>%
  bind_rows(.id = "pathway")

saveRDS(object = dfresvarcovar, file = "data/rembrandt/dfresvarcovar.rds")

