#!/usr/bin/env Rscript

# analyze_snps.R
#
# This script reads the VCF produced by snp-sites:
#   03_snp/TS_like_snps.vcf
# and summarizes SNP differences across Atropa TS isoforms and the
# Datura TS candidate CDS.
#
# Output (in 05_results/):
#   TS_like_snp_counts.tsv
#   TS_like_snp_counts.png

library(tidyverse)
library(stringr)  # for string manipulation; part of tidyverse

# Create 05_results directory if it does not exist
if (!dir.exists("05_results")) {
  dir.create("05_results")
}

# 1. Read VCF (skip '##' meta lines)
vcf_raw <- read_tsv(
  "03_snp/TS_like_snps.vcf",
  comment = "##",
  col_types = cols(.default = "c")
)

# Fix header issue (#CHROM becomes CHROM)
names(vcf_raw)[names(vcf_raw) == "#CHROM"] <- "CHROM"

# Identify sample columns
fixed_cols <- c("CHROM","POS","ID","REF","ALT","QUAL","FILTER","INFO","FORMAT")
sample_names <- setdiff(names(vcf_raw), fixed_cols)

# 2. If there are no SNPs → produce zero table
if (nrow(vcf_raw) == 0) {

  message("No SNPs detected by snp-sites for TS-like CDS.")
  snp_summary <- tibble(
    sample  = sample_names,
    alt_snps = 0
  )

} else {

  # Long format: one row per (site, sample)
  vcf_long <- vcf_raw |>
    pivot_longer(
      cols      = all_of(sample_names),
      names_to  = "sample",
      values_to = "genotype"
    )

  # Extract main allele and mark ALT genotypes
  # Genotype encoding: 0 = same as REF; 1,2,... = ALT alleles
  vcf_long2 <- vcf_long |>
    mutate(
      genotype_clean = str_replace(genotype, "\\|", "/"),
      gt_main = if_else(
        genotype_clean == ".",
        NA_character_,
        str_split_fixed(genotype_clean, "/", 2)[, 1]
      ),
      is_alt = !is.na(gt_main) & gt_main != "0"
    )

  # 3. Count ALT SNPs (sites that differ from the reference) per sample
  snp_summary <- vcf_long2 |>
    group_by(sample) |>
    summarise(
      alt_snps = sum(is_alt, na.rm = TRUE),
      .groups  = "drop"
    )
}

# 4. Save summary table
write_tsv(snp_summary, "05_results/TS_like_snp_counts.tsv")

# 5. Plot SNP counts (ALT SNPs relative to reference)
p_snps <- snp_summary |>
  ggplot(aes(x = sample, y = alt_snps)) +
  geom_col() +
  labs(
    x = "Sequence (Atropa TS isoforms and Datura TS candidate)",
    y = "Number of SNPs different from reference",
    title = "SNP differences in TS and TS-like CDS"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

ggsave("05_results/TS_like_snp_counts.png", p_snps, width = 7, height = 5)
