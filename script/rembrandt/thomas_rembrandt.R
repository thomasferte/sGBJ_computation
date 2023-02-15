library(dplyr)

##### import pathways
pathways=GSA::GSA.read.gmt("data/rembrandt/c6.all.v7.1.symbols.gmt")
liste_pathways=pathways$genesets
liste_names=pathways$geneset.names

##### import data
datas_tot=readRDS("data/rembrandt/dfGenesAndClinical.rds") %>%
  select(-all_of(c("SUBJECT_ID",
                   "PARENT_ID", "TYPE",
                   "TIMEPOINT", "AGE_RANGE",
                   "GENDER",
                   "WHO_GRADE", "RACE",
                   "INSTITUTION_NAME", "KARNOFSKY",
                   "NEURO_EXAM_SCORE", "DISEASE_EVAL_MRI",
                   "STEROID_DOSE_STATUS", "ANTI_CONVULSANT_STATUS",
                   "PRIOR_THERAPY_RADIATION_TYPE", "PRIOR_THERAPY_CHEMO_AGENT_NAME",
                   "PRIOR_THERAPY_SURGERY_TUMOR_HISTOLOGY", "PRIOR_THERAPY_PROCEDURE",
                   "PRIOR_THERAPY_SURGERY_OUTCOME", "ON_THERAPY_RADIATION_SITE",
                   "ON_THERAPY_RADIATION_TYPE", "ON_THERAPY_CHEMO_AGENT_NAME",
                   "ON_THERAPY_SURGERY_HIST_DIAG", "ON_THERAPY_SURGERY_TITLE",
                   "ON_THERAPY_SURGERY_OUTCOME", "PRIOR_THERAPY_SURGERY_OUTCOME_2",
                   "PT_NAME2", "PRIOR_THERAPY_SURGERY_OUTCOME_1",
                   "PT_NAME1", "GENE_EXP",
                   "COPY_NUMBER"))) %>%
  filter(DISEASE_TYPE %in% c("ASTROCYTOMA","GBM","OLIGODENDROGLIOMA"),
         !is.na(EVENT_OS))

lapply(liste_pathways, FUN = function(path){
  print(path)
  ncol(datas_tot[,colnames(datas_tot) %in% path])
})

counts_pathway=datas_tot[,colnames(datas_tot)%in%liste_pathways[[path]]]
patients=datas_tot[,c(1,3,2,4)]
patients=as.data.frame(patients)
st=as.numeric(patients[,2])
Recurrence=as.factor(patients[,3])

colnames(patients)=c("ID","st","Recurrence","type")
datas=cbind(patients,counts_pathway)
datas=as.data.frame(datas)
datas[,2]=as.numeric(as.character(datas[,2]))
