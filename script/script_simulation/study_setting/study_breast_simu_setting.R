library(dplyr)
library(survival)
library(parallel)

##### load data
lsdata <- readRDS(file = "data/breast_cancer/datamanaged.rds")
datas_clean = lsdata$data
liste_pathways = lsdata$pathways

##### test 1 pathway
# pathway_i <- liste_pathways[[1]]
extract_varcovar <- function(pathway_i){
  library(dplyr)
  library(survival)
  
  pathway_i <- pathway_i[pathway_i %in% colnames(datas_clean)]
  
  # return NULL if no gene in the pathway
  if(length(pathway_i) == 0) return()
  
  ##### cox beta and significance by gene
  dfCox <- lapply(pathway_i,
         FUN = function(gene_i){
           form <- paste0("Surv(time, event) ~ `", gene_i, "`")
           
           cox_model <- coxph(as.formula(form),
                   data = datas_clean) %>%
             summary()
           
           cox_model$coefficients %>%
             janitor::clean_names() %>%
             as.data.frame() %>%
             dplyr::select(coef, se_coef, pr_z) %>%
             dplyr::mutate(GENE = gene_i, .before = 1) %>%
             return(.)
         }) %>%
    bind_rows() %>%
    mutate(SIGN = pr_z < 0.05)
  
  ##### get the variance covariance and correlation
  mat_var_covar <- datas_clean %>%
    select(all_of(pathway_i)) %>%
    na.omit() %>%
    var()
  
  mat_corr <- datas_clean %>%
    select(all_of(pathway_i)) %>%
    na.omit() %>%
    cor()
  
  dfVariance <- diag(mat_var_covar) %>%
    as.data.frame() %>%
    janitor::clean_names() %>%
    rename("VARIANCE" = "x") %>%
    tibble::rownames_to_column(var = "GENE")
  
  # dfCovar <- mat_var_covar %>%
  #   as.data.frame() %>%
  #   tibble::rownames_to_column(var = "GENE") %>%
  #   tidyr::pivot_longer(cols = c(everything(), -"GENE"),
  #                       names_to = "GENE2",
  #                       values_to = "COVARIANCE") %>%
  #   # remove variance
  #   filter(GENE != GENE2) %>%
  #   left_join(dfCox %>% select(GENE, SIGN), by = "GENE") %>%
  #   left_join(dfCox %>% select(GENE, SIGN2 = SIGN), by = c("GENE2" = "GENE")) %>%
  #   group_by(GENE) %>%
  #   mutate(mean_covariance = mean(COVARIANCE)) %>%
  #   ungroup() %>%
  #   filter(SIGN == SIGN2) %>%
  #   group_by(GENE, mean_covariance) %>%
  #   summarise(mean_covar_by_sign = mean(COVARIANCE),
  #             .groups = "drop")
  
  dfCorr <- mat_corr %>%
    as.data.frame() %>%
    tibble::rownames_to_column(var = "GENE") %>%
    tidyr::pivot_longer(cols = c(everything(), -"GENE"),
                        names_to = "GENE2",
                        values_to = "CORRELATION") %>%
    # remove variance
    filter(GENE != GENE2) %>%
    left_join(dfCox %>% select(GENE, SIGN), by = "GENE") %>%
    left_join(dfCox %>% select(GENE, SIGN2 = SIGN), by = c("GENE2" = "GENE"))
    
  dfCoxVariance <- dfCox %>%
    left_join(dfVariance, by = "GENE")
  
  return(list(dfCoxVariance = dfCoxVariance,
              dfCorr = dfCorr))
}

##### parallel work
num_cores <- parallel::detectCores()-1
cl <- makeCluster(num_cores)
doParallel::registerDoParallel(cl)
clusterExport(cl,list('extract_varcovar','liste_pathways', 'datas_clean'))
results <- c(parLapply(cl,liste_pathways,fun=extract_varcovar))

dfCoxVariance <- lapply(results, function(x) x$dfCoxVariance) %>% bind_rows(.id = "pathway")
dfCorr <- lapply(results, function(x) x$dfCorr) %>% bind_rows(.id = "pathway")

saveRDS(object = list(dfCoxVariance = dfCoxVariance,
                      dfCorr = dfCorr),
        file = "data/breast_cancer/dfresvarcovar.rds")

