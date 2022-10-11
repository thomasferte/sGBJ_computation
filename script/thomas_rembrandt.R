pathways=GSA.read.gmt("data/c6.all.v7.1.symbols.gmt")
liste_pathways=pathways$genesets
liste_names=pathways$geneset.names


datas_tot=readRDS("data/dfGenesAndClinical.rds")
datas_tot=datas_tot[,-c(1,3,5,6,11:34)]
datas_tot=datas_tot[,-c(2,3,7)]
datas_tot=datas_tot[!is.na(datas_tot[,2])&!is.na(datas_tot[,3]),]
datas_tot=datas_tot[datas_tot[,4]%in%c("ASTROCYTOMA","GBM","OLIGODENDROGLIOMA"),]


path=100

counts_pathway=datas_tot[,colnames(datas_tot)%in%liste_pathways[[path]]]
patients=datas_tot[,c(1,3,2,4)]
patients=as.data.frame(patients)
st=as.numeric(patients[,2])
Recurrence=as.factor(patients[,3])

colnames(patients)=c("ID","st","Recurrence","type")
datas=cbind(patients,counts_pathway)
datas=as.data.frame(datas)
datas[,2]=as.numeric(as.character(datas[,2]))
