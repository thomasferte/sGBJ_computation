
# load packages and functions ---------------------------------------------

library(tidyverse)
library(parallel)

lapply(list.files(path = "functions/", full.names = TRUE),
       source)

# generate data -----------------------------------------------------------

df_parameters <- expand.grid(nb_genes = c(10, 50, 100),
                             nb_observations = c(50, 100),
                             nperm_sGBJ = c(8, 40, 200, 1000, 5000),
                             iterations = 1:10)

run_one <- function(i, df) {
  frobenius <- Frobenius_sGBJ(
    case = 4,
    type = "H",
    nb_genes = df$nb_genes[i],
    nb_observations = df$nb_observations[i],
    nperm_sGBJ = df$nperm_sGBJ[i]
  )
  
  return(data.frame(case = 4,
                    type = "H",
                    nb_genes = df$nb_genes[i],
                    nb_observations = df$nb_observations[i],
                    nperm_sGBJ = df$nperm_sGBJ[i],
                    frobenius = frobenius))
}

ncores <- detectCores() - 1  # leave one core free

results <- mclapply(
  X = seq_len(nrow(df_parameters)),
  FUN = run_one,
  df = df_parameters,
  mc.cores = ncores
) |> 
  bind_rows()

saveRDS(object = results, file = "data/frobenius")

labs_nb_genes = paste0("Nb genes : ", c(10, 50, 100))
names(labs_nb_genes) <- c(10, 50, 100)

ggplot(results |> 
         mutate(nb_observations = as.factor(nb_observations)),
       mapping = aes(x = nperm_sGBJ, y = frobenius, color = nb_observations, group = interaction(nb_observations, nperm_sGBJ))) +
  geom_boxplot() +
  facet_grid(nb_genes ~ ., scales = "free_y", labeller = labeller(nb_genes = labs_nb_genes)) +
  scale_x_log10(breaks = c(8, 40, 200, 1000, 5000)) +
  annotation_logticks(sides = "bottom") +
  scale_color_manual(values = c("grey", "black")) +
  theme_bw() +
  labs(x = "Number of permutations (sGBJ)",
       y = "Frobenius distance",
       color = "Number of observations")



