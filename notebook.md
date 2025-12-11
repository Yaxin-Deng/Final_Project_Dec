# Project notebook

## 2025-12-01 — Project setup & raw data organization

**Rationale**

The old project folder was disorganized (raw data mixed with results, confusing file names).
Instructor feedback emphasized the need for a clean, reproducible directory structure.

**Process**

- Created new project directory:
```bash
mkdir -p TS_BAHD_project_final/{00_raw,02_blast,03_alignments,03_snp,04_phylogeny,05_results,scripts}
```
- Copied raw FASTA files from old project and standardized file names:

  - ANN02033_cds_JP.fna.txt → Datura_TS_candidate.cds.fa

  - DS_TS_ANN02033.prot.fa → Datura_TS_candidate.protein.fa

  - Clade3_Protein.fa → BAHD_clade3_ref_plus_DsTS.fa

  - DS_protein.faa → Datura_genome_protein.fa

- Started drafting protocol.md.

**Next step**
Write BLAST pipeline and confirm Datura TS-like orthologs.
## 2025-12-02 — BLASTP setup and first run
**Rationale**
To identify BAHD acyltransferases in *Datura stramonium*, I needed to BLAST published clade 3 BAHD sequences (including Atropa TS) against the Datura proteome.
**Process**
Wrote scripts/run_blast.sh using relative paths (instructor requirement).
Submitted job:
```bash
sbatch scripts/run_blast.sh
```
**Verification**
Checked creation of:

  - 02_blast/Datura_protein_db.*

  - 02_blast/blast_clade3_vs_Ds_proteome.tab
Confirmed BLAST output contains valid hits.
**Next step**
Summarize BLAST output in R.
## 2025-12-04 — R-based BLAST analysis
**Rationale**
Instructor requested that we include R-based analyses (plots/tables).
**Process**
In OSC RStudio:
```r
setwd("/fs/.../TS_BAHD_project_final")
source("scripts/analyze_blast.R")
```
Script produced:
  - 05_results/blast_top_hits_summary.tsv

  - 05_results/blast_top_hits.png
**Next step**
Align BAHD protein sequences for phylogeny.
## 2025-12-05 — MAFFT protein alignment for phylogeny
**Rationale**
To understand where the Datura TS-like enzyme sits in BAHD clade 3, I needed an alignment for tree building.
**Process**
Wrote:

scripts/mafft_bahd.slurm

Tried running MAFFT:
```bash
sbatch scripts/mafft_bahd.slurm
```
**Troubleshooting**
Slurm output showed:
```
mafft: command not found
module 'mafft' does not exist
```
**Fix**
Installed MAFFT into conda environment:
```bash
module load miniconda3
conda activate blast_env
conda install -c bioconda mafft
```
Re-ran job; output alignment file is valid.
**Next step**
Build a phylogenetic tree in R.
## 2025-12-05 — Phylogeny construction
**Process**
Initial error: wrong filename in plot_bahd_tree.R (an old name from previous messy project).

Corrected path:
```r
align_file <- "03_alignments/BAHD_clade3_plus_DsTS_aligned.fa"
```
Re-ran:
```r
source("scripts/plot_bahd_tree.R")
```
**Outputs generated**
  - 04_phylogeny/BAHD_tree_nj.nwk

  - 05_results/BAHD_tree_nj.pdf
**Next step**
Perform SNP analysis of TS CDS.
## 2025-12-07 — Preparing TS-like CDS for SNP analysis
**Rationale**
To compare Atropa TS isoforms with the Datura TS-like candidate, I needed a joint CDS FASTA file.
**Process**
Combined sequences:
```bash
cat 00_raw/Atropa_TS.cds.fa 00_raw/Datura_TS_candidate.cds.fa > 00_raw/TS_like_cds.fa
```
Submitted MAFFT job:
```bash
sbatch scripts/mafft_ts_cds.slurm
```
Output confirmed:

03_snp/TS_like_cds_aligned.fa
## 2025-12-07 — SNP-sites installation + SNP calling
**Issue**

snp-sites is not available as an OSC module.

**Fix**

Installed into conda env:
```bash
conda install -y snp-sites
```
**Process**

Ran SNP calling:
```bash
sbatch scripts/snp_ts_cds.slurm
```

Output:

03_snp/TS_like_snps.vcf

## 2025-12-08 — R-based SNP summary & plotting

**Issue**

While running:
```r
source("scripts/analyze_snps.R")
```

I got:
```
unused argument (name = "non_missing_calls")
```
**Diagnosis**

OSC uses an older dplyr version that does not support:

count(..., name=)

**Fix**

Replaced with:
```r
group_by(sample) |> summarise(non_missing_calls = n())
```

**Result**

Successfully generated:

  - 05_results/TS_like_snp_counts.tsv

  - 05_results/TS_like_snp_counts.png

**General cleanup (from feedback)**

  - Ensured raw data stays in 00_raw/

  - Ensured all results go to 05_results/

  - Ensured alignment and SNP intermediates go to 03_alignments / 03_snp

  - Added .gitignore to avoid committing raw data and large results

  - Used only relative paths inside scripts

  - Rewrote scripts to include set -euo pipefail and cd "$SLURM_SUBMIT_DIR"

  ## 2025-12-10 — Diagnosis of SNP counting issue & correction of analysis logic

**Problem**

While reviewing my SNP barplot and after instructor feedback, I realized that all sequences showed
the same SNP count. This was biologically unlikely and indicated that the metric being calculated
was incorrect.

**Diagnosis**

`snp-sites` outputs only positions where *at least one* sequence shows variation.  
This means:

- Every sample receives a genotype at each SNP position  
- Counting "non-missing genotype calls" (`genotype != "."`) will produce **the same number for every sequence**

This explains why my earlier barplot showed identical bar heights.

**Correct biological measure**

To quantify divergence among sequences, I need to count **ALT alleles** per sample:

- `0` = same as REF  
- `1`, `2`, … = true alternate allele  
- So SNP differences must be counted where allele ≠ 0  

**Fix implemented**

I rewrote part of `scripts/analyze_snps.R`:

```r
mutate(
  genotype_clean = str_replace(genotype, "\\|", "/"),
  gt_main = str_split_fixed(genotype_clean, "/", 2)[,1],
  is_alt = !is.na(gt_main) & gt_main != "0"
)
```
Then ALT SNPs were counted as:
```r
group_by(sample) |> summarise(alt_snps = sum(is_alt))
```
**Outcome**

The updated barplot now correctly reflects:

variation among the four Atropa TS isoforms

greater divergence between Atropa and Datura TS candidates

**Files updated**

- scripts/analyze_snps.R (final corrected version)

- 05_results/TS_like_snp_counts.tsv

- 05_results/TS_like_snp_counts.png

**Next steps**

Update protocol.md and final_report.md to reflect the corrected SNP metric and interpretation.