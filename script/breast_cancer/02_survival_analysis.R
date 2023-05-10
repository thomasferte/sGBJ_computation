##### load packages #####
library(dplyr)
library(ggplot2)
library(survival)
library(survminer)

##### survival analysis #####
lsdata <- readRDS(file = "data/breast_cancer/datamanaged.rds")

### marginal
surv_marginal <- survfit(Surv(time = time, event = event) ~ 1,
                         data = lsdata$data)

plot_marginal_km <- ggsurvplot(surv_marginal,
                               risk.table = TRUE,
                               conf.int = TRUE,
                               ggtheme = theme_bw(),
                               palette = "black")

ggsave(filename = "images/plot_marginal_km.pdf",
       plot = plot_marginal_km,
       device = "pdf",
       height = 6,
       width = 6)

### stratified 
surv_grade <- survfit(Surv(time = time, event = event) ~ grade,
                      data = lsdata$data)

plot_grade_km <- ggsurvplot(surv_grade,
                            risk.table = TRUE,
                            conf.int = TRUE,
                            palette = c("#FFCD4D", "#F48C06", "#9D0208"),
                            ggtheme = theme_bw())

ggsave(filename = "images/plot_grade_km.pdf",
       plot = plot_grade_km,
       device = "pdf",
       height = 6,
       width = 6)
