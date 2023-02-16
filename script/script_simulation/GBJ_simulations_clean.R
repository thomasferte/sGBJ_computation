##### load functions and package #####
library(dplyr)
library(doParallel)
library(parallel)

lapply(list.files(path = "functions/", full.names = TRUE),
       source)

##### hyperparameters #####

# paper default : 2000 repetition
# nb_observations = 50 # paper default = 50
# nb_genes = 50 # paper default = 50
# prop_sig_gene = 0.2 # pg = c(0.05, 0.1, 0.2)
# variance = 0.2 # paper default = 0.2
# case = 2 # case = c(1, 2, 3)
# type = "A" # type = c("A", "B", "C")
# censoring = 0.3 # censoring = c(0, 0.3)
# nb_permutation = 100 # paper default = 1000
# prop_two_periods = FALSE
# slam = 0.005

set.seed(2)

myfunction <- function(x){
  library(dplyr)
  fct_simulation_paper(nb_observations = 50,
                       nb_genes = 50,
                       prop_sig_gene = 0.2,
                       variance = 0.2,
                       case = 3,
                       type = "C",
                       censoring = 0.3,
                       nb_permutation = 3,
                       prop_two_periods = FALSE)
}


no_cores <- detectCores(logical = TRUE)
cl <- makeCluster(no_cores-1)  
registerDoParallel(cl)
clusterExport(cl, ls())
seq_compute <- 1:100

results<- c(parLapply(cl = cl,
                      X = seq_compute,
                      fun= myfunction))


results %>%
  bind_rows(.id = "iter") %>%
  mutate(signif = p_value < 0.05) %>%
  group_by(method) %>%
  summarise(power = sum(signif)/n())

##### save results #####
