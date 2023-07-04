#' rfpermutation
#'
#' @description Function which compute test statistics for rf with permutation
#'
#' @param vectime the time
#' @param vecevent the event
#' @param x the genes experession
#' @param nb_permutation the number of permutation
#'
#' @return A vector with the statistical test of global test, adewale test
#' @export
#'
rfpermutation=function(dfdata, nb_permutation = 10, ntree = 10){
  
  model <- randomForestSRC::rfsrc(Surv(time,event) ~ .,
                                  data = dfdata,
                                  ntree = ntree,
                                  importance = FALSE)
  oob_error <- model$err.rate[ntree]
  
  vec_ooberror <- pbapply::pblapply(X = 1:nb_permutation,
                                   FUN = function(b){
                                     seed <- as.numeric(Sys.time()) + b
                                     
                                     set.seed(seed)
                                     
                                     dfdatapermuted <- dfdata %>%
                                       dplyr::select(time, event) %>%
                                       dplyr::slice_sample(prop = 1, replace = FALSE) %>%
                                       bind_cols(dfdata %>% select(-c(time, event)))
                                     
                                     model <- randomForestSRC::rfsrc(Surv(time,event) ~ .,
                                                                     data = dfdatapermuted,
                                                                     ntree = ntree,
                                                                     importance = FALSE)
                                     oob_error <- model$err.rate[ntree]
                                     
                                     return(oob_error)
                                   }) %>%
    unlist()
  
    
  p.pvalue <- mean(oob_error > vec_ooberror)
  
  return(p.pvalue)
}
