##### load functions and package #####

source(file = "functions/fct_generate_varcovar.R")
source(file = "functions/fct_generate_beta.R")
source(file = "functions/fct_generate_survival_data.R")
source(file = "functions/fct_generate_data.R")
source(file = "functions/statsTest.R")
source(file = "functions/fct_simulation_paper.R")

library(dplyr)

##### hyperparameters #####

# paper default : 2000 repetition
nb_observations = 50 # paper default = 50
nb_genes = 50 # paper default = 50
prop_sig_gene = 0.2 # pg = c(0.05, 0.1, 0.2)
variance = 0.2 # paper default = 0.2
case = 2 # case = c(1, 2, 3)
type = "A" # type = c("A", "B", "C")
censoring = 0.3 # censoring = c(0, 0.3)
nb_permutation = 100 # paper default = 1000 

set.seed(2)
fct_simulation_paper(nb_observations = 50,
                     nb_genes = 50,
                     prop_sig_gene = 0.2,
                     variance = 0.2,
                     case = 1,
                     type = "A",
                     censoring = 0.3,
                     nb_permutation = 10)

##### save results #####