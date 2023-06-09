# plot porpotion of significant genes
fct_prop_sign_genes <- function(dfdata){
  dfnb_genes_frac <- dfdata$dfCoxVariance %>%
    group_by(pathway) %>%
    summarise(nb_genes = n(),
              nb_sign_genes = sum(SIGN))
  
  model_lm <- lm(nb_sign_genes ~ nb_genes,
                 dfnb_genes_frac)
  
  res <- dfnb_genes_frac %>%
    ggplot(mapping = aes(x = nb_genes, y = nb_sign_genes)) +
    geom_point(mapping = aes(color = paste0("pathway : Y = ",
                                            round(model_lm$coefficients[1], 2),
                                            " + X",
                                            round(model_lm$coefficients[2], 2)))) +
    ggplot2::geom_abline(show.legend = TRUE,
                         mapping = aes(intercept = model_lm$coefficients[1],
                                       slope = model_lm$coefficients[2])) +
    labs(x = "Nb genes",
         y = "Nb significant genes",
         color = "") +
    scale_color_manual(values = "#29335c") +
    theme_bw() +
    theme(legend.position = "bottom")
  
  return(res)
}

# study beta distribution
fct_beta_dist <- function(dfdata, nb_filter_plot = 3, caption){
  
  dfBetaType <- dfdata$dfCoxVariance %>%
    mutate(Type = case_when(coef < 0 & SIGN ~ "negative",
                            coef > 0 & SIGN ~ "positive",
                            !SIGN ~ "non significant"))
  
  table_beta <- dfBetaType %>%
    group_by(pathway) %>%
    summarise(prop_pos = sum(coef>0 & SIGN)/n(),
              prop_neg = sum(coef<0 & SIGN)/n(),
              prop_null = sum(!SIGN)/n(),
              .groups = "drop") %>%
    summarise_if(.predicate = is.numeric, .funs = mean) %>%
    knitr::kable(caption = caption) %>%
    kableExtra::kable_styling()
  
  df_multiple_genes <- dfBetaType %>%
    group_by(pathway) %>%
    summarise(n = n()) %>%
    filter(n >= nb_filter_plot)
  
  dfhp <- dfBetaType %>%
    summarise(mean = mean(coef, na.rm = TRUE),
              sd = sd(coef, na.rm = TRUE))
  
  plot_unique_beta <- df_multiple_genes %>%
    left_join(dfBetaType, by = c("pathway"), multiple = "all") %>%
    ggplot(mapping = aes(x = coef, group = pathway)) +
    geom_density(mapping = aes(color = "pathway")) +
    geom_function(inherit.aes = FALSE,
                  linewidth = 2,
                  fun = function(x) dnorm(x,
                                          mean = dfhp$mean[1],
                                          sd = dfhp$sd[1]),
                  mapping = aes(color = paste0("N(", round(dfhp$mean[1],2), ",", round(dfhp$sd[1],2), ")"))) +
    theme_bw() +
    theme(legend.position = "bottom") +
    scale_color_manual(values = c("#051923", "#00a6fb")) +
    labs(x = "Coefficient estimate",
         color = "")
  
  dfhp2 <- dfBetaType %>%
    group_by(Type) %>%
    summarise(mean = mean(coef, na.rm = T),
              sd = sd(coef, na.rm = T))
  
  df_multiple_genes <- dfBetaType %>%
    group_by(pathway, Type) %>%
    summarise(n = n()) %>%
    filter(n >= nb_filter_plot)
  
  plot_multiple_beta <- df_multiple_genes %>%
    left_join(dfBetaType, by = c("Type", "pathway"), multiple = "all") %>%
    ggplot(mapping = aes(x = coef, group = interaction(pathway,Type))) +
    geom_density(mapping = aes(color = Type), linewidth = 0.1) +
    geom_function(inherit.aes = FALSE,
                  linewidth = 2,
                  fun = function(x) dnorm(x,
                                          mean = dfhp2$mean[1],
                                          sd = dfhp2$sd[1]),
                  mapping = aes(color = paste0(dfhp2$Type[1], " ~ N(", round(dfhp2$mean[1],2), ",", round(dfhp2$sd[1],2), ")"))) +
    geom_function(inherit.aes = FALSE,
                  linewidth = 2,
                  fun = function(x) dnorm(x,
                                          mean = dfhp2$mean[2],
                                          sd = dfhp2$sd[2]),
                  mapping = aes(color = paste0(dfhp2$Type[2], " ~ N(", round(dfhp2$mean[2],2), ",", round(dfhp2$sd[2],2), ")"))) +
    geom_function(inherit.aes = FALSE,
                  linewidth = 2,
                  fun = function(x) dnorm(x,
                                          mean = dfhp2$mean[3],
                                          sd = dfhp2$sd[3]),
                  mapping = aes(color = paste0(dfhp2$Type[3], " ~ N(", round(dfhp2$mean[3],2), ",", round(dfhp2$sd[3],2), ")"))) +
    theme_bw() +
    theme(legend.position = "bottom") +
    scale_color_manual(values = c("#db2b39", "#db2b39", "#f3a712", "#f3a712", "#29335c", "#29335c")) +
    labs(x = "Coefficient estimate",
         color = "") +
    guides(color=guide_legend(ncol =1))
  
  return(list(table_beta = table_beta,
              plot_unique_beta = plot_unique_beta,
              plot_multiple_beta = plot_multiple_beta))
}

# plot variance
fct_plot_variance <- function(dfdata, nb_filter_plot = 2){
  res <- dfdata$dfCoxVariance %>%
    group_by(pathway) %>%
    mutate(n = n()) %>%
    filter(n >= nb_filter_plot) %>%
    ggplot(mapping = aes(x = VARIANCE, group = pathway)) +
    geom_density(mapping = aes(color = "pathway")) +
    scale_x_log10() +
    annotation_logticks(sides = "bottom") +
    theme_bw() +
    theme(legend.position = "bottom") +
    scale_color_manual(values = "#29335c") +
    labs(x = "Variance",
         color = "") +
    guides(color=guide_legend(ncol =1))
  
  return(res)
}

# plot correlation
fct_plot_correlation <- function(dfdata, nb_filter_plot = 3, caption){
  dfCorrbyType <- dfdata$dfCorr %>%
    mutate(Type = case_when(SIGN & SIGN2 ~ "sign with sign",
                            !SIGN & !SIGN2 ~ "non sign with non sign",
                            SIGN != SIGN2 ~ "sign with non sign"))
  
  vec_correlation <- dfCorrbyType %>%
    pull(CORRELATION)
  
  fit <- fitdistrplus::fitdist(data = (vec_correlation+1)/2, method = "mme", distr = "beta")
  
  df_multiple_genes <- dfCorrbyType %>%
    group_by(pathway) %>%
    summarise(n = n()) %>%
    filter(n >= nb_filter_plot)
  
  plot_unique <- df_multiple_genes %>%
    left_join(dfCorrbyType, by = c("pathway"), multiple = "all") %>%
    ggplot(mapping = aes(x = CORRELATION, group = pathway)) +
    geom_density(mapping = aes(color = "pathway"), linewidth = 0.5) +
    geom_function(inherit.aes = FALSE,
                  linewidth = 2,
                  fun = function(x) extraDistr::dnsbeta(x = x, min = -1, max = 1,
                                                        shape1 = fit$estimate["shape1"], shape2 = fit$estimate["shape2"]),
                  mapping = aes(color = paste0("Beta(", round(fit$estimate["shape1"],2), ",", round(fit$estimate["shape2"],2), ")"))) +
    theme_bw() +
    theme(legend.position = "bottom") +
    scale_color_manual(values = c("#051923", "#00a6fb")) +
    labs(x = "Correlation",
         color = "") +
    guides(color=guide_legend(ncol =1))
  
  dfshapes_correlation <- dfCorrbyType %>%
    group_split(Type) %>%
    lapply(FUN = function(x){
      fitdistrplus::fitdist(data = (x$CORRELATION+1)/2, method = "mme", distr = "beta")$estimate %>%
        as.data.frame() %>%
        tibble::rownames_to_column(var = "shape") %>%
        mutate(Type = unique(x$Type)) %>%
        return(.)
    }) %>%
    bind_rows() %>%
    rename("value" = ".") %>%
    tidyr::pivot_wider(names_from = shape, values_from = value)
  
  table_shapes_correlation <- dfshapes_correlation %>%
    knitr::kable(caption = caption) %>%
    kableExtra::kable_styling()
  
  lshapes_correlation <- dfshapes_correlation %>%  group_split(Type)
  names(lshapes_correlation) <- lapply(lshapes_correlation, function(x) x$Type)
  
  df_multiple_genes <- dfCorrbyType %>%
    group_by(pathway, Type) %>%
    summarise(n = n()) %>%
    filter(n >= nb_filter_plot)
  
  plot_multiple <- df_multiple_genes %>%
    left_join(dfCorrbyType, by = c("pathway", "Type"), multiple = "all") %>%
    ggplot(mapping = aes(x = CORRELATION, group = interaction(pathway, Type))) +
    geom_density(mapping = aes(color = Type), linewidth = 0.1) +
    geom_function(inherit.aes = FALSE,
                  linewidth = 2,
                  fun = function(x) extraDistr::dnsbeta(x = x, min = -1, max = 1,
                                                        shape1 = lshapes_correlation$`non sign with non sign`[["shape1"]], shape2 = lshapes_correlation$`non sign with non sign`[["shape2"]]),
                  mapping = aes(color = paste0(lshapes_correlation$`non sign with non sign`[["Type"]], " ~ Beta(", round(lshapes_correlation$`non sign with non sign`[["shape1"]],2), ",", round(lshapes_correlation$`non sign with non sign`[["shape2"]],2), ")"))) +
    geom_function(inherit.aes = FALSE,
                  linewidth = 2,
                  fun = function(x) extraDistr::dnsbeta(x = x, min = -1, max = 1,
                                                        shape1 = lshapes_correlation$`sign with non sign`[["shape1"]], shape2 = lshapes_correlation$`sign with non sign`[["shape2"]]),
                  mapping = aes(color = paste0(lshapes_correlation$`sign with non sign`[["Type"]], " ~ Beta(", round(lshapes_correlation$`sign with non sign`[["shape1"]],2), ",", round(lshapes_correlation$`sign with non sign`[["shape2"]],2), ")"))) +
    geom_function(inherit.aes = FALSE,
                  linewidth = 2,
                  fun = function(x) extraDistr::dnsbeta(x = x, min = -1, max = 1,
                                                        shape1 = lshapes_correlation$`sign with sign`[["shape1"]], shape2 = lshapes_correlation$`sign with sign`[["shape2"]]),
                  mapping = aes(color = paste0(lshapes_correlation$`sign with sign`[["Type"]], " ~ Beta(", round(lshapes_correlation$`sign with sign`[["shape1"]],2), ",", round(lshapes_correlation$`sign with sign`[["shape2"]],2), ")"))) +
    scale_color_manual(values = c("#db2b39", "#db2b39", "#f3a712", "#f3a712", "#29335c", "#29335c")) +
    theme_bw() +
    theme(legend.position = "bottom") +
    labs(x = "Correlation",
         color = "") +
    guides(color=guide_legend(ncol =1))
  
  return(list(plot_unique = plot_unique,
              plot_multiple = plot_multiple,
              table_shapes_correlation = table_shapes_correlation))
}
