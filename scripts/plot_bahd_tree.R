#!/usr/bin/env Rscript
# scripts/plot_bahd_tree.R
# Build a Neighbor-Joining tree from MAFFT-aligned BAHD proteins.
#
# Input:
#   03_alignments/BAHD_clade3_plus_DsTS_aligned.fa
#
# Output:
#   04_phylogeny/BAHD_tree_nj.nwk
#   05_results/BAHD_tree_nj.pdf
library(seqinr)
library(ape)

# 1. Set input and output paths (relative to project root)
align_file <- "03_alignments/BAHD_clade3_plus_DsTS_aligned.fa"
tree_nwk   <- "04_phylogeny/BAHD_tree_nj.nwk"
tree_pdf   <- "05_results/BAHD_tree_nj.pdf"

# 2. Basic checks
if (!file.exists(align_file)) {
  stop("Alignment file not found: ", align_file)
}
if (file.info(align_file)$size == 0) {
  stop("Alignment file is empty: ", align_file)
}

# 3. Make sure output dirs exist
if (!dir.exists("04_phylogeny")) {
  dir.create("04_phylogeny")
}
if (!dir.exists("05_results")) {
  dir.create("05_results")
}

# 4. Read alignment (format = FASTA protein alignment)
ali <- read.alignment(
  file   = align_file,
  format = "fasta"
)

# 5. Distance matrix (1 - identity)
d <- dist.alignment(ali, "identity")

# 6. Neighbor-Joining tree
tree <- nj(d)

# 7. Save Newick tree
write.tree(tree, file = tree_nwk)

# 8. Save PDF tree plot
pdf(tree_pdf, width = 7, height = 7)
plot(tree, cex = 0.5)
title("BAHD clade 3 and Datura TS candidate (NJ tree)")
dev.off()

