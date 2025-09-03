#to open the SRR30916323.fastq.gz file
gunzip *.fastq.gz

#got long read directly from NCBI
#got short reads using SRAtoolkit
module load sratoolkit.3.0.7
fasterq-dump SRR30916324 --split-files

#quality check
module load fastqc-0.11.7
fastqc SRR30916324_1.fastq
fastqc SRR30916324_2.fastq


#trimming 
module load trimmomatic-0.36
java -jar $TRIMMOMATIC PE SRR30916324_1.fastq SRR30916324_2.fastq SRR30916324_1_paired.fastq SRR30916324_1_unpaired.fastq SRR30916324_2_paired.fastq SRR30916324_2_unpaired.fastq SLIDINGWINDOW:4:28 MINLEN:50


#loading Unicycler for assembly
module load unicycler
#Dependencies:
module load racon
module load samtools-1.7
unicycler -1 SRR30916324_1_paired.fastq -2 SRR30916324_2_paired.fastq -l SRR30916323.fastq -o Assembled_output --threads 8 --no_pilon

#checking completeness of the genome
module load checkm
checkm lineage_wf -t 8 -x fasta Assembled_output/ checkm_output/



