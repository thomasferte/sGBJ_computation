##### load package #####
library(dplyr)
library(ggplot2)
library(stringr)

##### functions #####
fct_generate_fig1 <- function(data,
                              subtitle = "(A) Non proportional hazard",
                              confint = FALSE){
  vec_labels_type <- paste0("Type ", c("A", "B", "C", "D", "E", "F"))
  names(vec_labels_type) <- c("A", "B", "C", "D", "E", "F")
  vec_labels_case <- paste0("Case (", c("I", "II", "III", "IV", "V"), ")")
  names(vec_labels_case) <- c(1:length(vec_labels_case))
  
  res <- data %>%
    mutate(p_val_sig = p_value < 0.05) %>%
    group_by(hp_row, method, prop_sig_gene, case, type, censoring) %>%
    summarise(success = sum(p_val_sig),
              trials = n()) %>%
    # wait for case 41
    filter(!is.na(success)) %>%
    ungroup() %>%
    mutate(power = binom::binom.confint(x = success, n = trials, methods = "exact")$mean,
           lower = binom::binom.confint(x = success, n = trials, methods = "exact")$lower,
           upper = binom::binom.confint(x = success, n = trials, methods = "exact")$upper) %>%
    mutate(censoring = factor(censoring,
                              levels = c(0, 0.3),
                              labels = c("0%", "30%")),
           method = factor(method,
                           levels = c("Global Boost Test",
                                      "Wald Test",
                                      "Global Test",
                                      "sGBJ"))) %>%
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
         lty = "Censoring proportion",
         subtitle = subtitle) +
    lims(y = c(0, 1))
  
  if(confint){
    res <- res +
      ggplot2::geom_errorbar(mapping = aes(ymin = lower, ymax = upper),
                             width = 0)
  }
  
  return(res)
}

##### data #####

dfScenario1 <- readRDS(here::here("data/dfScenario_breast_rembrandt.rds")) %>%
  tibble::rowid_to_column(var = "hp_row")

dfScenario2 <- readRDS(here::here("data/dfScenario_breast_rembrandt_to_finish.rds")) %>%
  tibble::rowid_to_column(var = "hp_row")

dfres1 <- list.files(here::here("data/result_simu_rembrandt_breast/result_9799043/"), recursive = T, full.names = T) %>%
  lapply(FUN = readRDS) %>%
  bind_rows() %>%
  inner_join(dfScenario1, by = "hp_row")

dfres2 <- list.files(here::here("data/result_simu_rembrandt_breast/result_9839694/"), recursive = T, full.names = T) %>%
  lapply(FUN = readRDS) %>%
  bind_rows() %>%
  inner_join(dfScenario2, by = "hp_row")

dfres <- bind_rows(dfres1, dfres2) %>%
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

# plot_simu
