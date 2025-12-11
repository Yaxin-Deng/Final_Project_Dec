# Project protocol: BAHD acyltransferases and TS-like enzymes in *Datura stramonium*

**Author**: Yaxin Deng
**Project directory**: /fs/ess/PAS2880/users/dengyaxin1156/TS_BAHD_project_final/
**Purpose**: Provide a complete, reproducible workflow for identifying and comparing BAHD acyltransferases and TS-like enzymes in *Datura stramonium*.
Anyone with access to this repository, the OSC cluster, and data files in 00_raw/ should be able to reproduce all results.
## 1. Data description

All raw files are stored in 00_raw/ and excluded from Git tracking via .gitignore.
### 1.1 BAHD clade 3 reference proteins

Protein accessions were obtained from Figure 2E of: 

Zeng et al. (2024), **Discovering a mitochondrion-localized BAHDacyltransferase involved in calystegine biosynthesis and engineering the production of *3β*-tigloyloxytropane**

For each accession, the corresponding protein FASTA was retrieved from NCBI Protein using its accession number. I add the Datura TS-like enzyme protein into this file.

All sequences were combined into:
```
00_raw/BAHD_clade3_ref_plus_DsTS.fa
```

This file also includes the putative *Datura stramonium* TS candidate protein.
### 1.2 *Atropa belladonna* TS CDS

Four A. belladonna TS isoforms were provided by the instructor and stored as:
```
00_raw/Atropa_TS.cds.fa
```
### 1.3 *Datura stramonium* TS candidate CDS
```
00_raw/Datura_TS_candidate.cds.fa
```
A combined FASTA containing all TS-like CDS was created as:
```
00_raw/TS_like_cds.fa
```
1.4 *D. stramonium* proteome
A lab-provided protein FASTA was used for BLAST searches:
```
00_raw/Datura_genome_protein.fa
```
## 2. Software environment

All tools used in this project:

- BLAST+
- MAFFT
- snp-sites
- R / tidyverse / ape (OSC RStudio environment)

OSC did not provide modules for MAFFT or snp-sites during this project.  
Following course recommendations for reproducible environments, both tools were installed in the  
existing `blast_env` Conda environment that was already used earlier in class:

```bash
module load miniconda3/24.1.2-py310
conda activate blast_env
conda install -y -c bioconda mafft snp-sites
```
**At OSC:**
```bash
module load miniconda3/24.1.2-py310
conda activate blast_env
```
All Slurm scripts therefore begin by loading miniconda and activating blast_env before running

blast_env contains:

- MAFFT

- snp-sites

- BLAST+

## 3. Directory structure
```
00_raw/              Raw input data (gitignored)
02_blast/            BLAST databases + results
03_alignments/       Protein and CDS alignments
03_snp/              SNP VCF + aligned CDS
04_phylogeny/        Newick tree files
05_results/          Final figures + summary tables
scripts/             All bash and R scripts
protocol.md          This file
notebook.md          Notebook-style logs
final_report.md      Written report

```
## 4. Workflow overview

The full workflow:

1. BLASTp: Identify Datura proteins matching BAHD clade 3.

2. MAFFT: Align BAHD protein sequences.

3. Phylogeny: Build a neighbor-joining tree.

4. TS-like CDS alignment using MAFFT.

5. SNP calling using snp-sites.

6. R analysis: BLAST summary, phylogeny plotting, SNP visualization.

All scripts use only relative paths to ensure portability and full reproducibility.

## 5. Detailed steps
### 5.1 BLAST analysis (protein)
**Goal**: Identify Datura proteins similar to BAHD clade 3 sequences.
**Input:**
```
00_raw/BAHD_clade3_ref_plus_DsTS.fa
00_raw/Datura_genome_protein.fa
```
**Script**: scripts/run_blast.sh
This script:

1. Loads BLAST+

2. Builds a protein database from Datura_genome_protein.fa

3. Runs blastp using the BAHD reference proteins as queries

4. Writes output to:
```
02_blast/blast_clade3_vs_Ds_proteome.tab
```
**Run:**
```bash
sbatch scripts/run_blast.sh
```
## 5.2 Protein alignment and 
### 5.2.1 MAFFT alignment
**Input:**
```
00_raw/BAHD_clade3_ref_plus_DsTS.fa
```
**Script**: scripts/mafft_bahd.slurm
Output:
```
03_alignments/BAHD_clade3_plus_DsTS_aligned.fa
```
Run:
```bash
sbatch scripts/mafft_bahd.slurm
```
### 5.2.2 Phylogeny construction (RStudio)
**Script:**
```bash
scripts/plot_bahd_tree.R
```
This script:

1. Reads MAFFT alignment

2. Computes distance matrix (dist.alignment)

3. Builds neighbor-joining tree (nj())

4. Saves:
```
04_phylogeny/BAHD_tree.nwk
05_results/BAHD_tree_nj.pdf
```
Run in RStudio:
```r
setwd("TS_BAHD_project_final")
source("scripts/plot_bahd_tree.R")
```
## 5.3 TS-like CDS alignment + SNP 
### Rationale for SNP analysis 

SNP analysis was included to compare sequence variation among TS-like CDS across *Atropa* and 
*Datura*. Divergence at the coding level can indicate potential functional differences between 
isoforms and across species, especially in BAHD acyltransferases where small amino acid changes 
may alter substrate preference or catalytic efficiency.

### 5.3.1 MAFFT alignment of CDS
**Input:**
```
00_raw/TS_like_cds.fa
```
**Script:** scripts/mafft_ts_cds.slurm
Output:
```
03_snp/TS_like_cds_aligned.fa
```
Run:
```bash
sbatch scripts/mafft_ts_cds.slurm
```
### 5.3.2 SNP calling using snp-sites
**Script:** scripts/snp_ts_cds.slurm
Output:
```
03_snp/TS_like_snps.vcf
```
Run:
```bash
sbatch scripts/snp_ts_cds.slurm
```
## 5.4 R analyses: BLAST + SNP + phylogeny
### 5.4.1 BLAST top-hit summary
**Script:** scripts/analyze_blast.R
Output:
```bash
05_results/blast_top_hits_summary.tsv
05_results/blast_top_hits.png
```
Run:
```r
source("scripts/analyze_blast.R")
```
### 5.4.2 SNP summary and rationale

The SNP analysis compares coding sequence divergence among the four *Atropa belladonna* TS
isoforms and the *Datura stramonium* TS candidate. Initially, the script attempted to quantify the
number of “non-missing genotype calls,” but this approach was incorrect because `snp-sites`
outputs only variable positions; therefore all sequences appeared to have the same count.

This issue was diagnosed and the SNP workflow was corrected.

The final version of `scripts/analyze_snps.R` instead counts **ALT alleles** for each sequence:

- A genotype of `0` indicates the same allele as the reference (usually the first sequence).
- A genotype of `1`, `2`, … indicates an alternate allele, i.e., a true SNP relative to the reference.

The final metric, `alt_snps`, reflects how many SNP sites differ from the reference sequence.
This approach provides a meaningful estimate of CDS divergence and is appropriate for distinguishing 
intraspecific isoform differences (among *Atropa* sequences) from interspecific divergence  
(between *Atropa* and *Datura*).

**Script:**  
`scripts/analyze_snps.R`

**Output:**  
```
05_results/TS_like_snp_counts.tsv
05_results/TS_like_snp_counts.png
```


**Run in RStudio:**  
```r
source("scripts/analyze_snps.R")
```
## 6. Full reproducibility: minimal command list

Anyone can reproduce the full workflow using:
```bash
sbatch scripts/run_blast.sh
sbatch scripts/mafft_bahd.slurm
sbatch scripts/mafft_ts_cds.slurm
sbatch scripts/snp_ts_cds.slurm
```
Then in RStudio:
```r
source("scripts/analyze_blast.R")
source("scripts/plot_bahd_tree.R")
source("scripts/analyze_snps.R")
```
These commands reproduce all results shown in the final report from raw FASTA files.

## 7. Notes on project organization
Raw data are not tracked in Git (00_raw/ is gitignored).

All results required for the report are in 05_results/.