library(tidyverse)
library(breastCancerNKI)
library(msigdbr)

set.seed(1)

data(nki)

##### Phenotype data #####
phenotype_data <- pData(nki) |> 
  as_tibble() |> 
  select("ID" = "samplename",
         "evdeath" = "e.os",
         "tsurv" = "t.os",
         "evmeta" = "e.dmfs",
         "tmeta" = "t.dmfs",
         "age" = "age",
         "grade" = "grade") |> 
  mutate(event = as.numeric(evdeath == 1 | evmeta == 1),
         time = tmeta/365.25,
         time_follow_up = if_else(tsurv > tmeta, tsurv, tmeta)/365.25) %>%
  select(ID, grade, event, time, time_follow_up, age) |> 
  na.omit()

##### Pathway data #####

pathway_gene <- msigdbr(
  species = "Homo sapiens", # For human pathways
  category = "C2",         # C2 category
  subcategory = "KEGG"  # Canonical Pathways, KEGG
) |> 
  select(gene_symbol, gs_name) |> 
  as_tibble()

##### Pathway - probe corresponding #####

gene_probe <- fData(nki) |> 
  select(probe, gene_symbol = NCBI.gene.symbol) |> 
  na.omit() |> 
  as_tibble()

##### Expression data #####
raw_expr <- exprs(nki)

### remove > 10% missing

bool_probes <- raw_expr |> 
  apply(MARGIN = 1, FUN = function(x) mean(is.na(x))<=0.1) 

### impute by knn similar to https://doi.org/10.1371/journal.pcbi.1004791 

expr_no_missing <- impute::impute.knn(raw_expr[bool_probes,], rng.seed = 123)$data

### to dataframe format

expression_data <- expr_no_missing |> 
  t() |> 
  as.data.frame() |> 
  tibble::rownames_to_column(var = "ID") |> 
  as_tibble() |> 
  tidyr::pivot_longer(cols = -ID,
                      names_to = "probe",
                      values_to = "expression") |> 
  inner_join(gene_probe, by = "probe") |> 
  filter(gene_symbol %in% unique(pathway_gene$gene_symbol)) |> 
  group_by(ID, gene_symbol) |> 
  summarise(expression = mean(expression, na.rm = TRUE), .groups = "drop") |> 
  tidyr::pivot_wider(names_from = gene_symbol, values_from = expression)

##### Merge all data #####

df_all <- phenotype_data %>%
  inner_join(expression_data, by = "ID")

### pathways
saveRDS(object = list(data = df_all,
                      pathways = pathway_gene),
        file = "data/breast_cancer/datamanaged2.rds")

