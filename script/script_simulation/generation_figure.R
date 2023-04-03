

results=read.table("comparaison_survival_sets_bis_corr_beta6_bis_2000_thomas.txt")
colnames(results)=c("ite","beta","corr","cens","prop","size","gt","wt","bst","gbj")

lines=seq(1,length(results[,1]),by=2)
results=results[lines,]
results_size=results

results=results_size[results_size[,6]==50,-6]
combinaisons=read.table("simulations_table.txt",header=TRUE)
for (i in 1:length(combinaisons[,1])){
  
  if (combinaisons[i,1]==0.3){
    combinaisons[i,1]=0.4
  }
  if (combinaisons[i,1]==0.1){
    combinaisons[i,1]=0.3
  }
  if (combinaisons[i,1]==0.5){
    combinaisons[i,1]=0.5
  }
  
}
gt=numeric(length(combinaisons[,1]))
wt=numeric(length(combinaisons[,1]))
gbt=numeric(length(combinaisons[,1]))
gbj=numeric(length(combinaisons[,1]))
for (i in 1:length(combinaisons[,1])){
  results_combinaison=results[results[,2]==combinaisons[i,4]&results[,3]==combinaisons[i,2]&results[,4]==combinaisons[i,3]&results[,5]==combinaisons[i,1],]
  #results_combinaison=distinct(results_combinaison,ite, .keep_all= TRUE)
  gt[i]=length(results_combinaison[results_combinaison[,6]<0.05,1])/length(results_combinaison[,1])
  wt[i]=length(results_combinaison[results_combinaison[,7]<0.05,1])/length(results_combinaison[,1])
  gbt[i]=length(results_combinaison[results_combinaison[,8]<0.05,1])/length(results_combinaison[,1])
  gbj[i]=length(results_combinaison[results_combinaison[,9]<0.05,1])/length(results_combinaison[,1])
}

resultats=cbind(combinaisons,gbj,gt,wt,gbt)

resultats_total=resultats
library(reshape2)
library(ggplot2)
datas=melt(resultats,measure.vars=c("gbj","gt","wt","gbt"))
colnames(datas)=c("cp","Corr","Censoring","beta","Method","Power")
for (i in 1:length(datas[,1])){
  if (datas[i,2]==1){
    datas[i,2]="(I)"
  }
  if (datas[i,2]=="2"){
    datas[i,2]="(III)"
  }
  if (datas[i,2]=="3"){
    datas[i,2]="(IV)"
  }
  if (datas[i,2]=="4"){
    datas[i,2]="(II)"
  }
  if (datas[i,4]==1){
    datas[i,4]="A"
  }
  if (datas[i,4]=="2"){
    datas[i,4]="B"
  }
  
}
datas[,2]=as.factor(datas[,2])
datas[,3]=as.factor(datas[,3])
datas[,4]=as.factor(datas[,4])
datas=datas[datas[,4]=="A"|datas[,4]=="B",]
datas=datas[!datas[,2]=="(IV)",]
ggplot(datas,aes(x=cp,y=Power))+
  geom_line(aes(linetype=Censoring, color=Method),size=1)+
  facet_grid(beta~Corr)+geom_point(aes(color=Method))+ scale_colour_viridis_d() + xlab("Percentage of significant genes")

