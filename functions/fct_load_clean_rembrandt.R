fct_load_clean_rembrandt <- function(path = here::here("data/rembrandt/dfGenesAndClinical.rds")){
  df_rembrandt = readRDS(path)
  
  df_rembrandt_clean <- df_rembrandt |> 
    filter(DISEASE_TYPE %in% c("ASTROCYTOMA", "OLIGODENDROGLIOMA"),
           !is.na(OVERALL_SURVIVAL_MONTHS),
           !is.na(EVENT_OS),
           GENDER != "",
           AGE_RANGE != "") |> 
    select(-c(SUBJECT_ID,
              COPY_NUMBER,
              GENE_EXP,
              PARENT_ID,
              TYPE,
              TIMEPOINT,
              WHO_GRADE,
              RACE,
              INSTITUTION_NAME,
              KARNOFSKY,
              NEURO_EXAM_SCORE,
              DISEASE_EVAL_MRI,
              STEROID_DOSE_STATUS,
              ANTI_CONVULSANT_STATUS,
              starts_with("PRIOR_THERAPY_"),
              starts_with("ON_THERAPY"),
              starts_with("PT_NAME"))) |> 
    mutate(GENDER = as.factor(GENDER),
           AGE_RANGE = as.factor(AGE_RANGE),
           AGE_RANGE = forcats::fct_collapse(AGE_RANGE,
                                             "< 40" = c("15-19","20-24",
                                                        "25-29", "30-34",
                                                        "35-39"),
                                             ">= 40" = c("40-44","45-49",
                                                         "50-54","55-59",
                                                         "60-64","65-69",
                                                         "70-74","75-79",
                                                         "80-84","85-89"))) |> 
    sjlabelled::var_labels(AGE_RANGE = "Age",
                           GENDER = "Sex",
                           EVENT_OS = "Death",
                           OVERALL_SURVIVAL_MONTHS = "Follow-up period in months",
                           DISEASE_TYPE = "Tumor type")
  
  return(df_rembrandt_clean)
}
