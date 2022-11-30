#!/bin/bash

#Illumina fastq files alignment and duplicate marking
# Alignment
sentieon=/path/to/sentieon-genomics-202112.04/bin/sentieon

$sentieon bwa mem -t 16 -K 10000000 -R '@RG\tID:003\tSM:HG003\tPL:ILLUMINA' -Y /path/to/reference/ref.fna \
    /path/to/fastq-illumina/MPHG003_S2_L002_R1_001.fastq.gz /path/to/fastq-illumina/MPHG003_S2_L002_R2_001.fastq.gz | \
    $sentieon util sort -t 16 --sam2bam -o /path/to/bam_illumina/file_sorted.bam -i -

# Duplicate marking
$sentieon driver -r /path/to/references/ref.fna -t 16 -i ./bam_illumina/HG003_sorted.bam --algo LocusCollector \
    --fun score_info /path/to/bam_illumina/HG003_score.txt.gz
$sentieon driver -r ./references/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna -t 16 -i ./bam_illumina/HG003_sorted.bam --algo Dedup \
    --score_info ./bam_illumina/HG003_score.txt.gz HG003_deduped.bam

