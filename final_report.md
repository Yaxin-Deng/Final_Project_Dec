# Final Report — Tropane Alkaloid BAHD Acyltransferases in Datura stramonium

- Author: Yaxin Deng
- Course: AU25 PLNTPTH 5006 - Comput Omics Data (37851)
- Repository: Final_Project_Dec

## Abstract

Tropane alkaloids in *Atropa belladonna* and *Datura stramonium* undergo acylation reactions catalyzed by BAHD acyltransferases such as tigloyltransferase (TS). The TS enzyme in *Datura* has not been characterized, but BAHD enzymes are strong candidates due to their conserved acyl-CoA–dependent catalytic mechanism.
Using BLAST, phylogenetic analysis, MAFFT alignments, SNP-sites, and R-based visualization, I evaluated whether a putative *D. stramonium* BAHD protein represents a tigloyltransferase homolog. Results show (1) high similarity of the Datura candidate to known clade 3 BAHDs, (2) phylogenetic clustering with Atropa TS, and (3) moderate sequence divergence at the CDS level. Together, these results strongly support the hypothesis that the Datura candidate is a BAHD-family TS-like enzyme involved in tropane alkaloid biosynthesis.

## 1. Introduction
Tropane alkaloids are specialized metabolites found across the Solanaceae. A key modification is tigloylation of the tropane scaffold, catalyzed in A. belladonna by the tigloyltransferase (TS), a member of the BAHD acyltransferase family. BAHD enzymes share:

- the conserved **HXXXD catalytic motif**,

- the **DFGWG structural motif**,

- acyl-CoA–dependent activity,

- substantial divergence in substrate selectivity.

The TS enzyme responsible for tigloylation in Datura stramonium has not been experimentally identified. Because BAHD enzymes catalyze late-stage acylations in many pathways, a strong hypothesis is that the Datura TS also belongs to clade 3 BAHDs.

**Goals of this project:**

1. Identify BAHD homologs in Datura using BLAST.

2. Place the Datura candidate into a BAHD phylogenetic context.

3. Compare TS-like CDS sequences between Atropa and Datura.

4. Evaluate whether the Datura candidate is a plausible tigloyltransferase.

## 2. Methods
### 2.1 Data and File Organization

All raw sequences were stored in `00_raw/`:

- BAHD clade 3 reference proteins (from Zeng et al. 2024 Fig. 2E)

- Atropa belladonna TS CDS isoforms

- Datura stramonium TS candidate CDS and protein

- Datura proteome FASTA

Project analysis scripts were placed in `scripts/`, intermediate results in `02_blast`, `03_alignments`, `03_snp`, and final figures/tables in `05_results`.

### 2.2 BLAST Analysis

**Goal:** Identify Datura proteins most similar to clade 3 BAHD acyltransferases.

**Process:**

- Built a protein BLAST database from D. stramonium proteome.

- Queried clade 3 BAHD proteins using blastp (outfmt 6).

- Selected top hits using analyze_blast.R.

**Outputs:**

- `05_results/blast_top_hits_summary.tsv`

- `05_results/blast_top_hits.png`
## Relationship between BAHD acyltransferases and the putative Datura stramonium tigloyltransferase

### 2.3 Protein Alignment and Phylogeny
**Goal:** Determine the evolutionary relationship between the Datura TS candidate and BAHD clade 3.

**Process:**

    1. MAFFT alignment (mafft_bahd.slurm)

    2. Distance matrix using seqinr::dist.alignment()

    3. Neighbor-joining tree using ape::nj()

    4. Output of Newick tree and PDF plot

**Outputs:**

- `04_phylogeny/BAHD_tree_nj.nwk`

- `05_results/BAHD_tree_nj.pdf`

### 2.4 SNP Analysis of TS-like CDS

**Goal:** Compare sequence divergence among TS-like CDS from Atropa and Datura.

**Updated, final SNP workflow**

Because the earlier (incorrect) version counted “non-missing genotype calls,” the pipeline was updated to a biologically correct method:

**All sequences were compared to a reference (Atropa TS isoform 1)**

For each sequence, the number of CDS positions differing from the reference was counted.

**Process:**

    1. Combine Atropa TS isoforms + Datura candidate CDS → TS_like_cds.fa

    2. Align using MAFFT (mafft_ts_cds.slurm)

    3. Call SNPs using snp-sites (snp_ts_cds.slurm)

    4. Count SNP differences per sequence in R (analyze_snps.R)

**Outputs:**

- `05_results/TS_like_snp_diff.tsv`

- `05_results/TS_like_snp_diff.png`

## 3. Results
### 3.1 BLAST reveals strong similarity between Datura TS candidate and BAHD clade 3

The top BLAST hits show:

- Many Datura proteins have **70–100% identity** with known clade 3 BAHDs.

- The putative Datura TS (ANN02033) is among the highest-scoring hits.

- Datura acyltransferases form a tight similarity cluster with Atropa TS and other BAHD enzymes involved in specialized metabolism.

**Interpretation:**
Datura contains BAHD enzymes highly similar to tigloyltransferase candidates.


### 3.2 Phylogeny places the Datura TS candidate within BAHD clade 3

The neighbor-joining tree shows:

- The Datura TS candidate clusters inside clade 3 BAHDs.

- It groups near Atropa BAHD enzymes known to participate in tropane alkaloid or acylsugar acylation pathways.

- No evidence of deep divergence or misclassification.

**Interpretation:**
The Datura candidate is evolutionarily consistent with BAHD acyltransferases that catalyze CoA-dependent acylations.

### 3.3 Updated SNP Analysis: sequence divergence among TS-like CDS

- The updated SNP plot (TS_like_snp_counts.png) shows:

- Atropa isoforms differ from the reference Atropa isoform by ~750–900 SNPs, indicating strong intra-species CDS diversity.

- The Datura TS candidate differs from the same reference by only ~100 SNPs, much lower than the Atropa isoform–isoform differences.

The outlier Datura candidate (GWHTBOWM027404) shows the smallest divergence.

Importantly:

**The BAHD catalytic motifs HXXXD and DFGWG are fully conserved across all CDS.**

**Interpretation:**

- The Datura TS candidate is more similar to Atropa TS than many Atropa isoforms are to each other.

- High similarity supports preserved catalytic function.

- Divergence outside conserved motifs may reflect species-specific substrate preferences or metabolic specialization.
## 4. Discussion
### 4.1 Evidence supporting the Datura TS candidate as a tigloyltransferase

Across all analyses:

| Analysis           | Evidence supporting TS function                                                              |
| ------------------ | -------------------------------------------------------------------------------------------- |
| **BLAST**          | High identity to clade 3 BAHD acyltransferases                                               |
| **Phylogeny**      | Clusters inside BAHD clade 3; near Atropa TS                                                 |
| **SNP divergence** | Conserved catalytic core; moderate sequence divergence consistent with functional adaptation |

These data support a model where:

- The Datura TS candidate is a BAHD enzyme with conserved functional motifs.

- Divergent SNPs outside catalytic motifs may tune substrate affinity or enzyme kinetics.

- The enzyme plausibly catalyzes tigloyl-CoA transfer reactions in Datura’s tropane alkaloid pathway.

## 5. Conclusion

The combined BLAST, phylogenetic, and SNP analyses provide strong computational evidence that the Datura stramonium TS candidate is a bona fide BAHD-family acyltransferase and a plausible tigloyltransferase. Experimental biochemical characterization will be required to confirm substrate specificity and catalytic properties, but the sequence-based analysis supports its functional role in tropane alkaloid biosynthesis.

## 6. Reproducibility

All analyses can be reproduced using the scripts in the repository:
```bash
sbatch scripts/run_blast.sh
sbatch scripts/mafft_bahd.slurm
sbatch scripts/mafft_ts_cds.slurm
sbatch scripts/snp_ts_cds.slurm
```
Then in OSC RStudio:
```r
source("scripts/analyze_blast.R")
source("scripts/plot_bahd_tree.R")
source("scripts/analyze_snps.R")
```
Raw data are stored at:
`TS_BAHD_project_final/00_raw/`
Raw input data are stored on OSC at:

  `/fs/ess/PAS2880/users/dengyaxin1156/TS_BAHD_project_final/00_raw/`

These files are not tracked in Git to avoid committing large FASTA datasets.
Anyone re-running this project should place the corresponding input files
into 00_raw/ following the filenames listed in protocol.md.