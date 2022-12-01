#!/bin/bash

#Illumina fastq files alignment and duplicate marking
# Alignment
sentieon=/path/to/sentieon-genomics-202112.04/bin/sentieon

$sentieon bwa mem -t 16 -K 10000000 -R '@RG\tID:003\tSM:HG003\tPL:ILLUMINA' -Y /path/to/reference/ref.fa \
    /path/to/fastq-illumina/fq1.fastq.gz /path/to/fastq-illumina/fq2.fastq.gz | \
    $sentieon util sort -t 16 --sam2bam -o /path/to/bam_illumina/file_sorted.bam -i -

# Duplicate marking
$sentieon driver -r /path/to/reference/ref.fa -t 16 -i /path/to/bam_illumina/file_sorted.bam --algo LocusCollector \
    --fun score_info /path/to/bam_illumina/file_score.txt.gz
$sentieon driver -r /path/to/reference/ref.fa -t 16 -i /path/to/bam_illumina/file_sorted.bam --algo Dedup \
    --score_info /path/to/bam_illumina/file_score.txt.gz \
    /path/to/bam_illumina/file_deduped.bam

