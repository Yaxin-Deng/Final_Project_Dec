#!/bin/bash
#
# run_blast.sh
#
# Identify *Datura stramonium* proteins related to clade 3 BAHD acyltransferases.
#
# Input (relative to project root):
#   00_raw/Datura_genome_protein.fa
#   00_raw/BAHD_clade3_ref_plus_DsTS.fa
#
# Output:
#   02_blast/Datura_protein_db.*               (BLAST protein database)
#   02_blast/blast_clade3_vs_Ds_proteome.tab  (BLASTP results, outfmt 6)

#SBATCH --job-name=blast_bahd
#SBATCH --account=PAS2880
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --output=02_blast/blast_bahd_%j.out

set -euo pipefail

cd "${SLURM_SUBMIT_DIR}"

module load blast-plus/2.16.0

mkdir -p 02_blast

makeblastdb -in 00_raw/Datura_genome_protein.fa \
            -dbtype prot \
            -out 02_blast/Datura_protein_db

blastp -query 00_raw/BAHD_clade3_ref_plus_DsTS.fa \
       -db 02_blast/Datura_protein_db \
       -outfmt 6 \
       -out 02_blast/blast_clade3_vs_Ds_proteome.tab
