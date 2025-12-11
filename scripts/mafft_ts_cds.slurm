#!/bin/bash
#
# mafft_ts_cds.slurm
#
# Multiple sequence alignment of *Atropa belladonna* TS CDS isoforms
# and the *Datura stramonium* TS candidate CDS.
#
# Input:
#   00_raw/TS_like_cds.fa
#     (combined file containing Atropa_TS.cds.fa + Datura_TS_candidate.cds.fa)
#
# Output:
#   03_snp/TS_like_cds_aligned.fa
#
#SBATCH --job-name=mafft_ts_cds
#SBATCH --account=PAS2880
#SBATCH --time=00:30:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --output=03_snp/mafft_ts_cds_%j.out
set -euo pipefail

cd "${SLURM_SUBMIT_DIR}"

module load miniconda3/24.1.2-py310
conda activate blast_env

mkdir -p 03_snp

mafft --auto 00_raw/TS_like_cds.fa \
  > 03_snp/TS_like_cds_aligned.fa
