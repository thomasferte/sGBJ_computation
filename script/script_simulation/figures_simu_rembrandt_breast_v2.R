##### load package #####
library(dplyr)
library(ggplot2)
##### data #####

dfres <- list.files("data/result_10187723/", recursive = T, full.names = T) %>%
  lapply(FUN = readRDS) %>%
  bind_rows() %>%
  mutate(case_type = paste0("Case : ", case, " ; Type : ", type),
         n_p = paste0("N = ", nb_observations, " ; NG = ", nb_genes),
         prop_sig_gene = as.factor(prop_sig_gene)) %>%
  mutate(p_val_sig = p_value < 0.05) %>%
  group_by(hp_row, method, prop_sig_gene, case_type, case, type, censoring, n_p, nb_observations, nb_genes) %>%
  summarise(power = sum(p_val_sig)/n(), .groups = "drop") %>%
  mutate(censoring = factor(censoring,
                            levels = c(0, 0.3),
                            labels = c("0%", "30%")),
         method = factor(method,
                         levels = c("Global Boost Test",
                                    "Wald Test",
                                    "Global Test",
                                    "sGBJ")))


##### plot #####
vec_labels_type <- paste0("Type ", c("A", "B", "C", "D", "E", "F"))
names(vec_labels_type) <- c("A", "B", "C", "D", "E", "F")
vec_labels_case <- paste0("Case (", c("I", "II", "III", "IV", "V"), ")")
names(vec_labels_case) <- c(1:length(vec_labels_case))

plot_simu <- dfres %>%
  ggplot(mapping = aes(x = prop_sig_gene,
                       y = power,
                       linetype = censoring,
                       color = censoring,
                       group = method,
                       fill = method)) +
  geom_bar(stat = "identity",
           position = "dodge") +
  scale_fill_viridis_d() +
  scale_color_manual(values = c("black", "red")) +
  facet_grid(case_type ~ n_p,
             labeller = labeller(case = vec_labels_case,
                                 type = vec_labels_type)) +
  labs(x = "Proportion of significant genes",
       y = "Statistical Power",
       fill = "Method",
       color = "Censoring proportion",
       lty = "Censoring proportion") +
  lims(y = c(0, 1)) +
  guides(fill = guide_legend(nrow = 4),
         lty = guide_legend(nrow = 2),
         color = guide_legend(nrow = 2)) +
  theme_bw() +
  theme(legend.position = "bottom")
