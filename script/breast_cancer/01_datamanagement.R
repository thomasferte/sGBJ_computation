##### load packages #####
library(dplyr)

# add method to grid.draw
grid.draw.ggsurvplot <- function(x){
  survminer:::print.ggsurvplot(x, newpage = FALSE)
}

##### load data #####
load("data/brest_cancer/BreastCancer-Vijver-Clinical.RData")
load("data/brest_cancer/BreastCancer-Vijver.RData")
load("data/brest_cancer/c2.cp.v2.5.GS.RData")

##### data management #####

### clinical data
df_clinical <- clin.data %>%
  mutate(event = as.numeric(evdeath == 1 | evmeta == 1),
         time = if_else(tsurv > tmeta, tmeta, tsurv)) %>%
  select(ID, grade, event, time, age)

### add counts
counts=t(llid_norm.mat)

df_all <- df_clinical %>%
  bind_cols(counts) %>%
  as_tibble()

### pathways
saveRDS(object = list(data = df_all,
                      pathways = GS.llids),
        file = "data/brest_cancer/datamanaged.rds")
