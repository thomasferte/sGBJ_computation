# function to analyse breast cancer dataset
fct_breast_cancer_analysis <- function(df_data,
                                       ls_pathways,
                                       vec_covariates,
                                       nb_permutation = 1000){
  
  vec_grade <- c("all", unique(df_data$grade))
  
  res <- tidyr::expand_grid(grade = vec_grade,
                            pathway = names(ls_pathways)) |> 
    apply(MARGIN = 1,
          FUN = function(row_i){
            grade_i <- row_i[["grade"]]
            pathway_i <- row_i[["pathway"]]
            
            message(paste0("------- pathway : ", pathway_i, ", grade : ", grade_i))
            
            vec_genes_of_pathway <- ls_pathways[[pathway_i]]
            
            if(grade_i != "all"){
              df_data_analysis <- df_data |> 
                filter(grade == grade_i)
            } else {
              df_data_analysis <- df_data
            }
            
            res <- fct_perform_tests(df_data_analysis = df_data_analysis,
                                     vec_genes_of_pathway = vec_genes_of_pathway,
                                     vec_covariates = vec_covariates,
                                     nb_permutation = nb_permutation) |> 
              mutate(pathway = pathway_i,
                     grade = grade_i,
                     .before = 1)
          }) |> 
    bind_rows()
  
  return(res)
  
}
