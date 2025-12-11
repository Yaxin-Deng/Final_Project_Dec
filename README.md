# Tropane Alkaloid Acyltransferases in *Datura stramonium*
### Final Project – AU25 PLNTPTH 5006 - Comput Omics Data (37851)

**Author:** Yaxin Deng  

**Instructor**: Jelmer Poelstra

**Project directory:** `/fs/ess/PAS2880/users/dengyaxin1156/TS_BAHD_project_final/`

---

## 1. Project Overview

Tropane alkaloids are specialized metabolites produced by Solanaceae plants including *Atropa belladonna* and *Datura stramonium*. In *A. belladonna*, tigloylation of the tropane core is performed by a BAHD-family acyltransferase known as TS (tigloyltransferase).

The TS enzyme in *D. stramonium* has not yet been identified experimentally. Because BAHD enzymes share conserved catalytic motifs (HXXXD, DFGWG) and perform CoA-dependent acyl transfer reactions, the hypothesis is that *Datura* also encodes a clade-3 BAHD enzyme that functions as the TS.

**Goal of this project:**  
Use BLAST, MAFFT, phylogenetic analysis, and SNP comparison to evaluate whether the lab-identified *Datura* TS candidate belongs to BAHD clade 3 and how similar it is to *Atropa* TS isoforms.

---

## 2. Data sources (raw data located in `00_raw/`)

- **BAHD clade 3 reference proteins**  
  Downloaded using accession numbers listed in Zeng et al. (2024), Fig. 2E.

- **Atropa TS isoforms (CDS)**  
  Four TS transcript variants provided from publicly available genomic resources.

- **Datura TS candidate (CDS + protein)**  
  Provided from the *D. stramonium* genome annotation used in the Blakeslee/Sadre lab.

- **Datura proteome**  
  Used as the BLASTp search space.

Raw data are excluded from version control using `.gitignore`.

---

## 3. Directory structure

```bash
TS_BAHD_project_final/
├── 00_raw/          # Raw FASTA input files (gitignored)
├── 02_blast/        # BLAST database + BLAST outputs
├── 03_alignments/   # Protein & CDS alignments from MAFFT
├── 03_snp/          # SNP VCF + aligned CDS
├── 04_phylogeny/    # Newick tree files
├── 05_results/      # Final figures & tables used in report
├── scripts/         # All bash/R scripts used in workflow
├── .gitignore       # Ignore 00_raw/, 02_blast, Datura_protein_db.*, *.out, *.log, *.slurmout, *.tmp
├── protocol.md      # Full protocol needed to rerun workflow
├── notebook.md      # Chronological analysis log
├── final_report.md  # Written report for the project
├── submission_notes.md 
└── README.md        # This file
```
## 4. Workflow summary
Step 1 — BLASTp search

Identify Datura proteins homologous to clade 3 BAHD enzymes.
Script: scripts/run_blast.sh

Step 2 — Protein alignment & phylogeny

Align BAHD clade 3 + Datura TS-like proteins and construct an NJ tree.

**Scripts:**

`mafft_bahd.slurm`

`plot_bahd_tree.R`

Step 3 — TS-like CDS alignment & SNP analysis

Align four Atropa TS isoforms with the Datura TS candidate and call SNPs.
Scripts:

`mafft_ts_cds.slurm`

`snp_ts_cds.slurm`

`analyze_snps.R`

Step 4 — R analyses

Generate summary tables and plots for BLAST, phylogeny, and SNP results.
Scripts:

`analyze_blast.R`

`plot_bahd_tree.R`

`analyze_snps.R`

## 5. Key results (found in 05_results/)

`blast_top_hits.png`
Datura proteins with highest similarity to clade 3 BAHD enzymes.

`BAHD_tree_nj.pdf`
Phylogeny placing the Datura TS candidate within BAHD clade 3.

`TS_like_snp_counts.png`
ALT-SNP differences across Atropa TS isoforms and Datura TS candidate.

Findings (summary):

BLAST results confirm strong homology between Datura candidate and BAHD acyltransferases.

Phylogeny places the Datura enzyme firmly in clade 3 with Atropa TS.

SNP analysis indicates divergence consistent with species-specific variation while retaining
conserved BAHD motifs.

## 6. Reproducibility
Run all computational steps:
```
sbatch scripts/run_blast.sh
sbatch scripts/mafft_bahd.slurm
sbatch scripts/mafft_ts_cds.slurm
sbatch scripts/snp_ts_cds.slurm
```

Run R visualizations:
```r
source("scripts/analyze_blast.R")
source("scripts/plot_bahd_tree.R")
source("scripts/analyze_snps.R")
```

Raw data located at:
`00_raw/ (not tracked in Git).`

## 7. Contact

For questions related to this project:
Yaxin Deng – dengyaxin1156@osu.edu