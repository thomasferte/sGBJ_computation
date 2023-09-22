##### load package #####
library(dplyr)
library(ggplot2)
##### data #####
ls_folder_path <- c("data/result_11020779", "data/result_10187723", "data/result_11021425/")

dfres <- lapply(ls_folder_path,
                FUN = function(x) list.files(x, recursive = T, full.names = T)) %>%
  unlist() %>%
  lapply(FUN = function(x) readRDS(x) %>%
           mutate(case = as.character(case),
                  prop_two_periods = as.character(prop_two_periods),
                  hp_row = as.character(hp_row))) %>%
  bind_rows() %>%
  mutate(case_type = paste0("Case : ", case, " ; Type : ", type),
         n_p = paste0("N = ", nb_observations, " ; NG = ", nb_genes),
         prop_sig_gene = as.factor(prop_sig_gene)) %>%
  mutate(p_val_sig = p_value < 0.05) %>%
  group_by(hp_row, method, prop_sig_gene, case_type, case, type, censoring, n_p, nb_observations, nb_genes) %>%
  summarise(success = sum(p_val_sig),
            trials = n(),
            mean_time = mean(time),
            power = success/trials,
            power_lower = binom::binom.confint(methods = "exact", x = success, n = trials)$lower,
            power_upper = binom::binom.confint(methods = "exact", x = success, n = trials)$upper,
            .groups = "drop") %>%
  select(-success, -trials) %>%
  mutate(censoring = factor(censoring,
                            levels = c(0, 0.3),
                            labels = c("0%", "30%")),
         method = factor(method,
                         levels = c("Global Boost Test",
                                    "Wald Test",
                                    "Global Test",
                                    "sGBJ")))


##### plot #####
plot_simu <- dfres %>%
  filter(type != "Z") %>%
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
  facet_grid(case_type ~ n_p) +
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

plot_simu_alpha <- dfres %>%
  filter(type == "Z") %>%
  ggplot(mapping = aes(x = method,
                       y = power,
                       ymin = power_lower,
                       ymax = power_upper,
                       linetype = censoring,
                       color = censoring,
                       group = method,
                       fill = method)) +
  geom_errorbar(width = 0) +
  geom_point(shape = 22,
             size = 3) +
  geom_hline(yintercept = 0.05, lty = 2) +
  scale_fill_viridis_d() +
  scale_color_manual(values = c("black", "red")) +
  facet_grid(case_type ~ n_p) +
  labs(x = "",
       y = "Type-I error",
       fill = "Method",
       color = "Censoring proportion",
       lty = "Censoring proportion") +
  guides(fill = guide_legend(nrow = 4),
         lty = guide_legend(nrow = 2),
         color = guide_legend(nrow = 2)) +
  theme_bw() +
  theme(legend.position = "right",
        axis.text.x = element_text(angle = 45, hjust=1))

# Time
dfrestime <- readRDS(file = "data/result_11020779_time.rds") %>%
  mutate(case_type = paste0("Case : ", case, " ; Type : ", type),
         n_p = paste0("N = ", nb_observations, " ; NG = ", nb_genes),
         prop_sig_gene = as.factor(prop_sig_gene)) %>%
  select(hp_row, method, prop_sig_gene, case_type, case, type, censoring, n_p, nb_observations, nb_genes, time) %>%
  mutate(censoring = factor(censoring,
                            levels = c(0, 0.3),
                            labels = c("0%", "30%")),
         method = factor(method,
                         levels = c("Global Boost Test",
                                    "Wald Test",
                                    "Global Test",
                                    "sGBJ")))

plot_time <- dfrestime %>%
  ggplot(mapping = aes(x = prop_sig_gene,
                       y = time,
                       linetype = censoring,
                       color = censoring,
                       group = method,
                       fill = method)) +
  geom_bar(stat = "identity",
           position = "dodge") +
  scale_fill_viridis_d() +
  scale_color_manual(values = c("black", "red")) +
  facet_grid(case_type ~ n_p) +
  labs(x = "Proportion of significant genes",
       y = "Computation time on 1 sample (seconds)",
       fill = "Method",
       color = "Censoring proportion",
       lty = "Censoring proportion") +
  guides(fill = guide_legend(nrow = 4),
         lty = guide_legend(nrow = 2),
         color = guide_legend(nrow = 2)) +
  theme_bw() +
  theme(legend.position = "bottom")
