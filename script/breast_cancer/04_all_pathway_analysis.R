##### load packages #####
library(dplyr)
library(ggplot2)
library(survival)
library(survminer)
library(parallel)

##### survival analysis #####
lsdata <- readRDS(file = "data/breast_cancer/datamanaged.rds")
ls_pathways <- lsdata$pathways
vec_grade <- unique(lsdata$data$grade)
nperm <- 1000

##### stratified #####
# vec_pathways <- ls_pathways[[1]]
# grade_i <- vec_grade[1]
# nperm <- 10

df_res_stratified <- mclapply(X = ls_pathways,
                              mc.cores = 19,
                              FUN = function(vec_pathways){
                                res <- lapply(X = vec_grade,
                                              FUN = function(grade_i){
                                                ##### PREP DATA
                                                dfdata <- lsdata$data %>% filter(grade == grade_i)
                                                
                                                surv_obj <- survival::Surv(time = dfdata$time,
                                                                           event = dfdata$event)
                                                
                                                factor_matrix <- dfdata %>%
                                                  select(any_of(vec_pathways))
                                                
                                                covariates <- dfdata %>% select(age)
                                                
                                                all_expl_features <- bind_cols(factor_matrix, covariates)
                                                
                                                alternative_hyp <- paste0("~ ",
                                                                          paste0("`", colnames(factor_matrix), "`", collapse = " + "))
                                                null_hyp <- paste0("~ ",
                                                                   paste0(colnames(covariates), collapse = " + "))
                                                
                                                ##### TESTS
                                                ### sGBJ
                                                sGBJ <- sGBJ::sGBJ(surv = surv_obj,
                                                                   factor_matrix = factor_matrix,
                                                                   covariates = covariates,
                                                                   nperm = nperm)$sGBJ_pvalue
                                                ### GBT
                                                GBT <- globalboosttest::globalboosttest(
                                                  X = factor_matrix,
                                                  Y = surv_obj,
                                                  Z = covariates,
                                                  nperm = nperm,
                                                  mstop = 500,
                                                  pvalueonly = TRUE
                                                )$pvalue |> 
                                                  as.numeric()
                                                ### WALD
                                                wald_pval <- Wald_Test_Perm(vectime = dfdata$time,
                                                                            vecevent = dfdata$event,
                                                                            x = dfdata %>% select(-time,-event) %>% as.matrix(),
                                                                            nb_permutation = nb_permutation)
                                                ### GT
                                                GT<-globaltest::gt(response = surv_obj,
                                                                   data = all_expl_features,
                                                                   null = as.formula(null_hyp),
                                                                   alternative = as.formula(alternative_hyp),
                                                                   model="cox",
                                                                   permutations = nb_permutation) |>
                                                  globaltest::p.value()
                                                
                                                ##### RESULTS
                                                res <- data.frame(pathway = pathway_i,
                                                                  grade = grade_i,
                                                                  nb_genes = ncol(factor_matrix),
                                                                  p_value = test$sGBJ_pvalue)         
                                                
                                                return(res)
                                              }) %>%
                                  bind_rows()
                                
                                return(res)
                              }) %>%
  bind_rows() %>%
  group_by(grade) %>%
  mutate(p_value_adjusted = p.adjust(p = p_value, method = "hochberg"))

# saveRDS(df_res_stratified, file = "data/breast_cancer/df_res_stratified.rds")
