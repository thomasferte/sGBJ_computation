##### load package #####
library(dplyr)
library(ggplot2)

##### functions #####

fct_generate_fig1 <- function(data){
  vec_labels_type <- paste0("Type ", c("A", "B", "C"))
  names(vec_labels_type) <- c("A", "B", "C")
  vec_labels_case <- paste0("Case (", c("I", "II", "III"), ")")
  names(vec_labels_case) <- c(1:3)
  
  res <- data %>%
    mutate(p_val_sig = p_value < 0.05) %>%
    group_by(hp_row, method, prop_sig_gene, case, type, censoring) %>%
    summarise(power = mean(p_val_sig)) %>%
    mutate(censoring = factor(censoring,
                              levels = c(0, 0.3),
                              labels = c("0%", "30%")),
           method = factor(method,
                           levels = c("Global Boost Test",
                                      "Wald Test",
                                      "Global Test",
                                      "sGBJ"))) %>%
    ungroup() %>%
    ggplot(mapping = aes(x = prop_sig_gene,
                         y = power,
                         color = method,
                         lty = censoring)) +
    geom_point() +
    geom_line(size = 1) +
    scale_color_viridis_d() +
    facet_grid(case ~ type,
               labeller = labeller(case = vec_labels_case,
                                   type = vec_labels_type)) +
    labs(x = "Proportion of significant genes",
         y = "Statistical Power",
         color = "Method",
         lty = "Censoring proportion") +
    lims(y = c(0, 1))
  
  return(res)
}

##### data #####

dfScenario <- readRDS("data/dfScenario.rds") %>%
  tibble::rowid_to_column(var = "hp_row")

dfres <- list.files("data/result_simu/results_simu1/", recursive = T, full.names = T) %>%
  lapply(FUN = readRDS) %>%
  bind_rows() %>%
  full_join(dfScenario, by = "hp_row")

##### plot #####
plot_prop_risk <- dfres %>%
  filter(prop_two_periods) %>%
  fct_generate_fig1

ggsave(filename = "images/plot_prop_risk.pdf",
       plot = plot_prop_risk,
       device = "pdf", height = 6, width = 6)

plot_high_power <- dfres %>%
  filter(!prop_two_periods) %>%
  fct_generate_fig1

ggsave(filename = "images/plot_high_power.pdf",
       plot = plot_high_power,
       device = "pdf", height = 6, width = 6)

saveRDS(object = list(plot_prop_risk = plot_prop_risk,
                      plot_high_power = plot_high_power),
        file = "results/figures_prophazard_highpower.rds")
