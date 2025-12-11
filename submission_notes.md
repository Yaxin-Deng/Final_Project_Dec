This section provides guidance for reproducing all analyses for grading purposes.

## 1. How to rerun the entire project

All analyses can be reproduced on OSC using the following steps.

Step 1 — Load Conda environment (contains MAFFT, BLAST+, snp-sites)
```bash
module load miniconda3/24.1.2-py310
conda activate blast_env
```
Step 2 — Run all Slurm jobs
```bash
sbatch scripts/run_blast.sh
sbatch scripts/mafft_bahd.slurm
sbatch scripts/mafft_ts_cds.slurm
sbatch scripts/snp_ts_cds.slurm
```
Step 3 — Run all R analyses

Open OSC RStudio and use Rscript:
```r
setwd("/fs/ess/PAS2880/users/<YOUR_USER>/TS_BAHD_project_final")
source("scripts/analyze_blast.R")
source("scripts/plot_bahd_tree.R")
source("scripts/analyze_snps.R")
```
All figures and summary tables will appear in:
`05_results/`

## 2. Files that should be ignored when grading

| Folder             | Contents                           | Notes                                    |
| ------------------ | ---------------------------------- | ---------------------------------------- |
| **00_raw/**        | Raw FASTA input files              | Git-ignored; provided separately on OSC  |
| **02_blast/**      | BLAST database + raw BLAST outputs | Intermediate files (not manually edited) |
| **03_alignments/** | MAFFT alignment outputs            | Automatically generated                  |
| **03_snp/**        | MAFFT CDS alignments + VCF         | Intermediate SNP detection results       |

Only `scripts/`, `protocol.md`, `notebook.md`, `final_report.md`, and `05_results/` should be evaluated.

## 3 Notes on environment and non-OSC modules

Because OSC does not provide MAFFT or snp-sites, both tools were installed into the course conda environment (blast_env), following course instructions on environment reproducibility.

Installation (already performed once):
```bash
module load miniconda3/24.1.2-py310
conda activate blast_env
conda install -y -c bioconda mafft snp-sites
```
This ensures that all steps can be rerun reliably on OSC without additional configuration.

## 4. Notes on data sources

All raw data in 00_raw/ are:

- Provided by the lab/instructor

- Downloaded from publicly available accession numbers

- Not modified by hand

- Required for reproducible execution of the scripts

These raw files are not tracked in Git, per assignment guidelines.