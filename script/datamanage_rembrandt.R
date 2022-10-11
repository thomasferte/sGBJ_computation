################################################# load packages ####################################
library(dplyr)
library(hgu133plus2.db)

################################################# import data ####################################

##### clinical data
GSE108474_REMBRANDT_Clinical <- read.table(file = "GSE108474_REMBRANDT_clinical.data.txt",
                                                 sep = "\t",
                                                 header = T)
##### gene-clinical mapping
GSE108474_REMBRANDT_Mapping <- read.table(file = "GSE108474_REMBRANDT_biospecimen_mapping_GEO.txt",
                                          sep = "\t",
                                          header = T) %>%
  mutate_all(.funs = function(x) gsub(pattern = "-", replacement = "_", x = x))

##### gene expression data
### import data
GSE108474_REMBRANDT_GeneExpression <- read.table(file = "GSE108474_REMBRANDT_GeneExpression.txt",
                                                 sep = "\t",
                                                 header = T,
                                                 row.names = 1) %>%
  tibble::rownames_to_column(var = "PROBEID")

### probe annotation
dfProbeGene <- AnnotationDbi::select(x = hgu133plus2.db,
                                     keys = GSE108474_REMBRANDT_GeneExpression$PROBEID,
                                     columns = c("PROBEID", "SYMBOL"),
                                     keytype = "PROBEID") %>%
  dplyr::distinct() %>%
  dplyr::rename("GENE" = "SYMBOL")

dfGenes <- dfProbeGene %>%
  dplyr::left_join(GSE108474_REMBRANDT_GeneExpression, by = "PROBEID") %>%
  ## fix patients id to map to clinical data
  dplyr::rename_with(.fn = function(x) ifelse(grepl(x,
                                                    pattern = "^X|^PROBEID|^GENE"),
                                              x,
                                              paste0("X", x)) %>%
                       gsub(pattern = "\\.",
                            replacement = "_",
                            x = .))

### transpose the dataframe and aggregate with the mean when a gene is identified by several probes
dfGenesWide <- dfGenes %>%
  dplyr::select(-PROBEID) %>%
  tidyr::pivot_longer(cols = X00518392_U133P2:XNormal_7_U133_P2,
                      names_to = "BIOSPECIMEN_ID",
                      values_to = "EXPRESSION") %>%
  dplyr::group_by(GENE, BIOSPECIMEN_ID) %>%
  ## some genes are identified by multiple probes, I take the mean over the different probes
  dplyr::summarise(EXPRESSION = mean(EXPRESSION)) %>%
  dplyr::ungroup() %>%
  tidyr::pivot_wider(id_cols = BIOSPECIMEN_ID,
                     names_from = GENE,
                     values_from = EXPRESSION)

################################################# merge data ####################################

### Merge the Clinical and genes dataset using the mapping
dfMerged <- GSE108474_REMBRANDT_Mapping %>%
  dplyr::left_join(GSE108474_REMBRANDT_Clinical, by = "SUBJECT_ID") %>%
  dplyr::left_join(dfGenesWide, by = "BIOSPECIMEN_ID")

### save the merged dataset
saveRDS(dfMerged, file = "dfGenesAndClinical.rds")
