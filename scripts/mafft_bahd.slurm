#!/bin/bash
#
# mafft_bahd.slurm
#
# Multiple sequence alignment of clade 3 BAHD proteins,
# including the *Atropa belladonna* TS and the *Datura stramonium* TS-like candidate.
#
# Input:
#   00_raw/BAHD_clade3_ref_plus_DsTS.fa
#
# Output:
#   03_alignments/BAHD_clade3_plus_DsTS_aligned.fa
#
# This script is written following course best practices:
# - uses relative paths only
# - uses Slurm for reproducible batch computation
# - includes proper error handling (set -euo pipefail)
# - loads software through the OSC module system + conda environment

#SBATCH --job-name=mafft_bahd
#SBATCH --account=PAS2880
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --output=03_alignments/mafft_bahd_%j.out

# Exit on error, undefined variable, or failed pipe component
set -euo pipefail


# Always work from the project root directory
cd "${SLURM_SUBMIT_DIR}"

# Load conda environment containing MAFFT
module load miniconda3/24.1.2-py310

source activate align_env
# Create output directory
mkdir -p 03_alignments
# Run MAFFT alignment
mafft --auto 00_raw/BAHD_clade3_ref_plus_DsTS.fa \
  > 03_alignments/BAHD_clade3_plus_DsTS_aligned.fa
