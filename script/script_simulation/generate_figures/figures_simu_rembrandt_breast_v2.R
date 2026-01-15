##### load package #####
library(dplyr)
library(ggplot2)
library(cowplot)

##### data #####
ls_folder_path <- c(
  "data/result_11020779",
  "data/result_10187723",
  "data/result_11021425/",
  "data/result_4352258",
  "data/result_4355641",
  "data/result_4374573",
  "data/result_4378211"
)


# Datamanagement ----------------------------------------------------------

dfres_indiv <- lapply(ls_folder_path,
                FUN = function(x) list.files(here::here(x), recursive = T, full.names = T)) %>%
  unlist() %>%
  lapply(FUN = function(x) readRDS(x) %>%
           mutate(case = as.character(case),
                  prop_two_periods = as.character(prop_two_periods),
                  hp_row = as.character(hp_row))) %>%
  bind_rows() %>%
  mutate(case_type = paste0("Case : ", case, " ; Type : ", type),
         n_p = paste0("N = ", nb_observations, " ; NG = ", nb_genes),
         prop_sig_gene = as.factor(prop_sig_gene),
         p_val_sig = p_value < 0.05,
         censoring = factor(censoring,
                            levels = c(0, 0.3),
                            labels = c("0%", "30%")),
         method = factor(method,
                         levels = c("HM",
                                    "Cauchy",
                                    "Global Boost Test",
                                    "Wald Test",
                                    "Global Test",
                                    "sGBJ")),
         case_type = gsub(x = case_type, pattern = "Type : G", replacement = "Type : A"),
         case_type = gsub(x = case_type, pattern = "Type : H", replacement = "Type : B"),
         case_type = gsub(x = case_type, pattern = "Type : I", replacement = "Type : C"),
         case_type = gsub(x = case_type, pattern = "Case : 4", replacement = "Case : (I)"),
         case_type = gsub(x = case_type, pattern = "Case : 5", replacement = "Case : (II)"),
         case_type = gsub(x = case_type, pattern = "Case : 6", replacement = "Case : (III)"),
         case_type = gsub(x = case_type, pattern = "Case : 7", replacement = "Case : (IV)"),
         case = factor(case,
                       levels = c(4, 5, 6, 7),
                       labels = c("Case : (I)", "Case : (II)", "Case : (III)", "Case : (IV)")),
         type = factor(type,
                       levels = c("G", "H", "I", "Z"),
                       labels = c("Type: A", "Type: B", "Type: C", "Type: Z")),
         n_p = as.factor(n_p),
         n_p = forcats::fct_relevel(n_p,
                                    "N = 50 ; NG = 10",
                                    "N = 50 ; NG = 50",
                                    "N = 50 ; NG = 100",
                                    "N = 100 ; NG = 10",
                                    "N = 100 ; NG = 50",
                                    "N = 100 ; NG = 100"))


dfres_ci <- dfres_indiv %>%
  group_by(hp_row, method, prop_sig_gene, case_type, case, type, censoring, n_p, nb_observations, nb_genes) %>%
  summarise(success = sum(p_val_sig),
            trials = n(),
            mean_time = mean(time),
            power = success/trials,
            power_lower = binom::binom.confint(methods = "exact", x = success, n = trials)$lower,
            power_upper = binom::binom.confint(methods = "exact", x = success, n = trials)$upper,
            .groups = "drop") %>%
  select(-success, -trials)

# Plots -------------------------------------------------------------------

##### Main plots

plot_power_simu <- dfres_ci |> 
  filter(type != "Type: Z", prop_sig_gene == 0.2, case != "Case : (IV)") %>%
  group_by(case_type, n_p) |> 
  mutate(max_power = max(power),
         rank = as.factor(dense_rank(-power))) |>
  ungroup() |> 
  ggplot(mapping = aes(x = n_p,
                       y = power,
                       ymin = power_lower,
                       ymax = power_upper,
                       group = method,
                       color = method)) +
  geom_point() +
  geom_line(linewidth = 1) +
  geom_errorbar(width = .1) +
  scale_color_viridis_d() +
  # scale_color_manual(values = c("red", "orange", "grey", "black")) +
  scale_y_continuous(limits = c(0,1), breaks = c(0, .5, 1)) +
  facet_grid(case ~ type) +
  labs(x = "",
       y = "Statistical Power",
       color = "") +
  guides(color = guide_legend(nrow = 2),
         lty = guide_legend(nrow = 2)) +
  theme_bw() +
  theme(legend.position = "right",
        axis.text.x = element_text(angle = 45, hjust=1),
        strip.text.y.right = element_text(angle = 0))
# plot_power_simu

plot_alpha_qqplot <- dfres_indiv |> 
  filter(type == "Type: Z", prop_sig_gene == 0.2, case != "Case : (IV)") %>%
  ggplot(mapping = aes(sample = p_value, color = method)) +
  geom_qq(distribution = qunif, shape = ".") +
  geom_abline(slope = 1, intercept = 0) +
  facet_grid(n_p ~ case) +
  scale_color_viridis_d() +
  guides(color = guide_legend(nrow = 2,
                              override.aes = list(shape = 16))) +
  labs(
    x = "Theoretical Quantiles (Uniform)",
    y = "Sample Quantiles"
  ) +
  theme_bw() +
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 45, hjust=1),
        strip.text.y.right = element_text(angle = 0))

plot_alpha_simu <- dfres_ci %>%
  filter(type == "Type: Z", prop_sig_gene == 0.2, case != "Case : (IV)") %>%
  ggplot(mapping = aes(x = n_p,
                       y = power,
                       ymin = power_lower,
                       ymax = power_upper,
                       group = method,
                       color = method)) +
  geom_point() +
  geom_line(linewidth = 1) +
  geom_errorbar(width = .1) +
  geom_hline(yintercept = 0.05, lty = 2) +
  scale_color_viridis_d() +
  scale_y_continuous(breaks = c(0.002, 0.01, 0.05), trans = "log") +
  facet_grid(case ~ type) +
  labs(x = "",
       y = "Type-I error",
       color = "") +
  guides(color = guide_legend(nrow = 2)) +
  theme_bw() +
  theme(legend.position = "right",
        axis.text.x = element_text(angle = 45, hjust=1),
        strip.text.y.right = element_text(angle = 0))

plot_simulation_power_alpha <- ggpubr::ggarrange(plot_power_simu, plot_alpha_simu,
                                                 nrow = 1,
                                                 common.legend = TRUE,
                                                 legend = "bottom",
                                                 widths = c(0.65, 0.35),
                                                 labels = c("A", "B"))

plot_simulation_power_alpha <- ggpubr::annotate_figure(plot_simulation_power_alpha,
                                                       bottom = grid::textGrob("Number of observations (N) and Number of Genes (NG)",
                                                                               gp = grid::gpar(cex = 1),
                                                                               vjust = -7))
# plot_simulation_power_alpha

### Supplementary analysis

## Case IV genes correlated at 0.9

plot_power_simu_case_IV <- dfres_ci |> 
  filter(type != "Type: Z", prop_sig_gene == 0.2, case == "Case : (IV)") %>%
  group_by(case_type, n_p) |> 
  mutate(max_power = max(power),
         rank = as.factor(dense_rank(-power))) |>
  ungroup() |> 
  ggplot(mapping = aes(x = n_p,
                       y = power,
                       ymin = power_lower,
                       ymax = power_upper,
                       group = method,
                       color = method)) +
  geom_point() +
  geom_line(linewidth = 1) +
  geom_errorbar(width = .1) +
  scale_color_viridis_d() +
  scale_y_continuous(limits = c(0,1), breaks = c(0, .5, 1)) +
  facet_grid(. ~ case_type) +
  labs(x = "",
       y = "Statistical Power",
       color = "") +
  guides(color = guide_legend(nrow = 2),
         lty = guide_legend(nrow = 2)) +
  theme_bw() +
  theme(legend.position = "right",
        axis.text.x = element_text(angle = 45, hjust=1),
        strip.text.y.right = element_text(angle = 0))

plot_alpha_qqplot_case_IV <- dfres_indiv |> 
  filter(type == "Type: Z", prop_sig_gene == 0.2, case == "Case : (IV)") %>%
  ggplot(mapping = aes(sample = p_value, color = method)) +
  geom_qq(distribution = qunif, shape = ".") +
  geom_abline(slope = 1, intercept = 0) +
  facet_grid(n_p ~ case_type) +
  scale_color_viridis_d() +
  guides(color = guide_legend(nrow = 2,
                              override.aes = list(shape = 16))) +
  labs(
    x = "Theoretical Quantiles (Uniform)",
    y = "Sample Quantiles"
  ) +
  theme_bw() +
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 45, hjust=1),
        strip.text.y.right = element_text(angle = 0))

# plot_alpha_simu_case_IV <- dfres_ci %>%
#   filter(type == "Type: Z", prop_sig_gene == 0.2, case == "Case : (IV)") %>%
#   ggplot(mapping = aes(x = n_p,
#                        y = power,
#                        ymin = power_lower,
#                        ymax = power_upper,
#                        group = method,
#                        color = method)) +
#   geom_point() +
#   geom_line(linewidth = 1) +
#   geom_errorbar(width = .1) +
#   geom_hline(yintercept = 0.05, lty = 2) +
#   scale_color_viridis_d() +
#   scale_y_continuous(breaks = c(0.002, 0.01, 0.05), trans = "log") +
#   facet_grid(case ~ type) +
#   labs(x = "",
#        y = "Type-I error",
#        color = "") +
#   guides(color = guide_legend(nrow = 2)) +
#   theme_bw() +
#   theme(legend.position = "right",
#         axis.text.x = element_text(angle = 45, hjust=1),
#         strip.text.y.right = element_text(angle = 0))

plot_simulation_case_IV <- ggpubr::ggarrange(
  plot_power_simu_case_IV, 
  plot_alpha_qqplot_case_IV,
  nrow = 1,
  common.legend = TRUE,
  legend = "bottom",
  widths = c(0.5, 0.5),
  labels = c("A", "B")
  )

## Proportion of significant genes

supp.labs_temp <- c("0.05", "0.1", "0.2")
supp.labs <- paste0("% sign genes : ", supp.labs_temp)
names(supp.labs) <- supp.labs_temp

plot_power_simu_prop_sign <- dfres_ci |> 
  filter(type == "Type: A", case == "Case : (III)") |> 
  group_by(case_type, n_p) |> 
  mutate(max_power = max(power),
         rank = as.factor(dense_rank(-power))) |>
  ungroup() |> 
  ggplot(mapping = aes(x = n_p,
                       y = power,
                       ymin = power_lower,
                       ymax = power_upper,
                       group = method,
                       color = method)) +
  geom_point() +
  geom_line(linewidth = 1) +
  geom_errorbar(width = .1) +
  scale_color_viridis_d() +
  scale_y_continuous(limits = c(0,1), breaks = c(0, .5, 1)) +
  facet_grid(prop_sig_gene ~ case_type,
             labeller = labeller(prop_sig_gene = supp.labs)) +
  labs(x = "",
       y = "Statistical Power",
       color = "") +
  guides(color = guide_legend(nrow = 2),
         lty = guide_legend(nrow = 2)) +
  theme_bw() +
  theme(legend.position = "right",
        axis.text.x = element_text(angle = 45, hjust=1),
        strip.text.y.right = element_text(angle = 90))

plot_alpha_qqplot_prop_sign <- dfres_indiv |> 
  filter(type == "Type: Z", case == "Case : (III)") |> 
  ggplot(mapping = aes(sample = p_value, color = method)) +
  geom_qq(distribution = qunif, shape = ".") +
  geom_abline(slope = 1, intercept = 0) +
  facet_grid(prop_sig_gene ~ case_type,
             labeller = labeller(prop_sig_gene = supp.labs)) +
  scale_color_viridis_d() +
  guides(color = guide_legend(nrow = 2,
                              override.aes = list(shape = 16))) +
  labs(
    x = "Theoretical Quantiles (Uniform)",
    y = "Sample Quantiles"
  ) +
  theme_bw() +
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 45, hjust=1),
        strip.text.y.right = element_text(angle = 90))

# plot_alpha_simu_prop_sign <- dfres_ci %>%
#   filter(type == "Type: Z", case == "Case : (III)") |> 
#   ggplot(mapping = aes(x = n_p,
#                        y = power,
#                        ymin = power_lower,
#                        ymax = power_upper,
#                        group = method,
#                        color = method)) +
#   geom_point() +
#   geom_line(linewidth = 1) +
#   geom_errorbar(width = .1) +
#   geom_hline(yintercept = 0.05, lty = 2) +
#   scale_color_viridis_d() +
#   scale_y_continuous(breaks = c(0.002, 0.01, 0.05), trans = "log") +
#   facet_grid(prop_sig_gene ~ type) +
#   labs(x = "",
#        y = "Type-I error",
#        color = "") +
#   guides(color = guide_legend(nrow = 2)) +
#   theme_bw() +
#   theme(legend.position = "right",
#         axis.text.x = element_text(angle = 45, hjust=1),
#         strip.text.y.right = element_text(angle = 0))

plot_simulation_prop_sign <- ggpubr::ggarrange(
  plot_power_simu_prop_sign, 
  plot_alpha_qqplot_prop_sign,
  nrow = 1,
  common.legend = TRUE,
  legend = "bottom",
  widths = c(0.5, 0.5),
  labels = c("A", "B")
)
