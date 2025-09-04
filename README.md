

#  README

## 1. Data sources

This task is based on on publicly available sequencing data from the study "Complete genome sequence of Pseudomonas aeruginosa YK01, a sequence type 16 isolated from a patient with keratitis" which aimed to construct a complete genome of 6.3 Mb was obtained for P. aeruginosa YK01 by combining Illumina 150-bp short reads and Nanopore long reads.. Whole genome sequencing was done Illumina
NextSeq 500 platform with 150-bp paired-end reads for short reads and Nanopore MinION sequencer Mk1B for long reads.

---

## 2. How to download

The data for the sample is available as raw reads are available on GenBank of NCBI under Bioproject: PRJNA1145087.
### Code for downloading

```bash
fasterq-dump SRR30916324 --split-files

```


---

## 3. How the workflow works
The workflow files is stored in workflow/ and it is divided into different steps:
The workflow files are stored in `workflow/`.

---

### Step 1 – Quality Check

**Purpose:** The workflow takes each FASTQ.qz file (raw reads), assess the quality of the reads and give the scores and overall stats on the quality of reads.
**Tools:** `fastqc`
**Inputs:** Raw reads FASTQ files (from `data/`)
**Outputs:** quality matrix (html)
**Command:**

```bash
module load fastqc-0.11.7
fastqc SRR30916324_1.fastq
fastqc SRR30916324_2.fastq                                         

```

---

### Step 2 - Reads Cleaning/Trimming

**Purpose:** Process reads to get clean, high-quality reads
**Tools:** 'Trimmomatic'
**Inputs:** fastq.gz files
**Outputs:** trimmed fastq.gz files
**Command:**

```bash
module load trimmomatic-0.36
java -jar $TRIMMOMATIC PE SRR30916324_1.fastq SRR30916324_2.fastq SRR30916324_1_paired.fastq SRR30916324_1_unpaired.fastq SRR30916324_2_paired.fastq SRR30916324_2_unpaired.fastq SLIDINGWINDOW:4:28 MINLEN:50

```
---

### Step 3 – Genome Assembly

**Purpose:** the pipeline assemblies the genome
**Tools:** 'unicycler', 'racon', 'samtools'
**Inputs:** fastq files
**Outputs:** .fasta
**Command:**
```bash
#loading Unicycler for assembly
module load unicycler
#Dependencies:
module load racon
module load samtools-1.7
unicycler -1 SRR30916324_1_paired.fastq -2 SRR30916324_2_paired.fastq -l SRR30916323.fastq -o Assembled_output --threads 8 --no_pilon


```
### Step 5 - Assess Genome Completeness

**Purpose:** This part of the workflow assesses the completeness of the assembled genome
**Tools:** 'checkm'
**Inputs:** bam file
**Outputs:** txt file
**Command:**

```bash
#checking completeness of the genome
module load checkm
checkm lineage_wf -t 8 -x fasta Assembled_output/ checkm_output/

```
---


prokka spades_output/contigs.fasta --outdir prokka_output --prefix PGRG5


```
---
