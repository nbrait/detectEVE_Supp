setwd("C:/Users/nadja/Documents/LaptopAsus/PhD/detectEVE_PC")

# Load necessary library
library(readr)
library(dplyr)

#################################

## Comparison selectivity

setwd("C:/Users/nadja/Documents/LaptopAsus/PhD/detectEVE_PC/selectivity/paper")
library(readr)
library(dplyr)
library(stringr)

# Read input files
paper <- read_tsv("paper_new.tsv") # metadata from used papers

# detectEVE input
RVDB_bed <- read_tsv("RVDB_all.bed", col_names = FALSE)
RVDB_cut <- read_tsv("RVDB_all_cut.tsv") # length min 250
RVDB_tsv <- read_tsv("RVDB_all.tsv")

# data management
RVDB_bed <- RVDB_bed %>%
  mutate(Contig = str_remove(X1, "\\.1$"))

RVDB_tsv <- RVDB_tsv %>%
  mutate(Contig = str_extract(locus, ".*(?=_[^_]+$)")) %>%
  mutate(Contig = str_remove(Contig, "\\.1$"))

RVDB_cut <- RVDB_cut %>%
  mutate(Contig = str_extract(locus, ".*(?=_[^_]+$)")) %>%
  mutate(Contig = str_remove(Contig, "\\.1$"))

# changing accessions according to other papers
mapping <- c(
  "JARHUA010000390" = "tig00030708_pilon",
  "JARHUA010000803" = "tig00029914_pilon",
  "JARHUA010000805" = "tig00027226_pilon",
  "NC_064875" = "idAnoDarlMG_H_01.Chr3",
  "NC_064873" = "idAnoDarlMG_H_01.ChrX",
  "NC_064874" = "idAnoDarlMG_H_01.Chr2"
)

RVDB_tsv <- RVDB_tsv %>%
  mutate(Contig = ifelse(Contig %in% names(mapping), mapping[Contig], Contig))
RVDB_cut <- RVDB_cut %>%
  mutate(Contig = ifelse(Contig %in% names(mapping), mapping[Contig], Contig))
RVDB_bed <- RVDB_bed %>%
  mutate(Contig = ifelse(Contig %in% names(mapping), mapping[Contig], Contig))


# comparison

RVDB_bed_table <- merge(paper, RVDB_bed, by = "Contig")
RVDB_tsv_table <- merge(paper, RVDB_tsv, by = "Contig")
RVDB_cut_table <- merge(paper, RVDB_cut, by = "Contig")

# find missing EVE hits
unmerged_RVDB_bed <- anti_join(paper, RVDB_bed, by = "Contig")
unmerged_RVDB_tsv <- anti_join(paper, RVDB_tsv, by = "Contig")
unmerged_RVDB_cut <- anti_join(paper, RVDB_cut, by = "Contig")

# write out
#write_tsv(RVDB_bed_table, "RVDB_bed_merged.tsv")
#write_tsv(RVDB_tsv_table, "RVDB_tsv_merged.tsv")
#write_tsv(unmerged_RVDB_bed, "RVDB_bed_unmerged.tsv")
#write_tsv(unmerged_RVDB_tsv, "RVDB_tsv_unmerged.tsv")

write_tsv(unmerged_RVDB_cut, "RVDB_cut_unmerged.tsv")
write_tsv(RVDB_cut_table, "RVDB_cut_merged.tsv")



# making sure its the right matches by calculating location overlaps
calculate_overlap <- function(range1, start2, stop2) {
  range1_split <- as.numeric(unlist(strsplit(range1, "-")))
  start1 <- range1_split[1]
  stop1 <- range1_split[2]
  
  overlap_start <- max(start1, start2)
  overlap_end <- min(stop1, stop2)
  overlap <- max(0, overlap_end - overlap_start + 1)
  return(overlap) 
}

RVDB_cut_table_filtered <- RVDB_cut_table %>%
  rowwise() %>%
  mutate(overlap = calculate_overlap(Location, start, stop)) %>%
  ungroup() %>%
  filter(overlap > 0)

write_tsv(RVDB_cut_table_filtered, "RVDB_cut_filtered.tsv")

RVDB_bed_table_filtered <- RVDB_bed_table %>%
  rowwise() %>%
  mutate(overlap = calculate_overlap(Location, X2, X3)) %>%
  ungroup() %>%
  filter(overlap > 0)

write_tsv(RVDB_bed_table_filtered, "RVDB_bed_filtered.tsv")

