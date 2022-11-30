#!/bin/bash


#first variant calling
$gatk --java-options "-Xmx200G" HaplotypeCaller --native-pair-hmm-threads 16 \
	-R ref.fa \
	-I file.bam \
	-O out.vcf
	
#extract SNPS and INDELS
$gatk --java-options "-Xmx50G" SelectVariants \
        -R ref.fa \
        -V out.vcf \
	-select-type SNP \
        -O raw_snps.vcf
$gatk --java-options "-Xmx50G" SelectVariants \
        -R ref.fa \
        -V out.vcf \
        -select-type INDEL \
        -O raw_indels.vcf

#Filter SNPS
$gatk --java-options "-Xmx50G" VariantFiltration \
        -R ref.fa \
        -V raw_snps.vcf \
        -O filtered_snps.vcf \
        -filter-name "QD_filter" -filter "QD < 2.0" \
        -filter-name "FS_filter" -filter "FS > 60.0" \
        -filter-name "MQ_filter" -filter "MQ < 40.0" \
        -filter-name "SOR_filter" -filter "SOR > 4.0" \
        -filter-name "MQRankSum_filter" -filter "MQRankSum < -12.5" \
        -filter-name "ReadPosRankSum_filter" -filter "ReadPosRankSum < -8.0" 

#Filter INDELs
$gatk --java-options "-Xmx50G" VariantFiltration \
        -R ref.fa \
        -V raw_indels.vcf \
	-O filtered_indels.vcf \
        -filter-name "QD_filter" -filter "QD < 2.0" \
        -filter-name "FS_filter" -filter "FS > 200.0" \
        -filter-name "SOR_filter" -filter "SOR > 10.0"

#Exclude Filtered Variants
$gatk --java-options "-Xmx50G" SelectVariants \
        --exclude-filtered \
        -V filtered_snps.vcf \
        -O bqsr_snps.vcf
$gatk --java-options "-Xmx50G" SelectVariants \
        --exclude-filtered \
        -V filtered_indels.vcf \
        -O bqsr_indels.vcf


#Base Quality Score Recalibration (BQSR)
$gatk --java-options "-Xmx50G" BaseRecalibrator --maximum-cycle-value 100000 \
        -R ref.fa \
        -I file.bam \
        --known-sites bqsr_snps.vcf \
        --known-sites bqsr_indels.vcf \
        -O recal_data.table

#Apply BQSR
$gatk --java-options "-Xmx50G" ApplyBQSR \
        -R ref.fa \
        -I file.bam \
        -bqsr recal_data.table \
        -O recal_reads.bam

#Second variant calling
$gatk --java-options "-Xmx200G" HaplotypeCaller --native-pair-hmm-threads 16 \
        -R ref.fa \
        -I recal_reads.bam \
        -O out_v2.vcf
        
#extract SNPS and INDELS from second vcf
$gatk --java-options "-Xmx50G" SelectVariants \
        -R ref.fa \
        -V out_v2.vcf \
	-select-type SNP \
        -O raw_snps_v2.vcf
$gatk --java-options "-Xmx50G" SelectVariants \
        -R ref.fa \
        -V out_v2.vcf \
        -select-type INDEL \
        -O raw_indels_v2.vcf

#Filter SNPS
$gatk --java-options "-Xmx50G" VariantFiltration \
        -R ref.fa \
        -V raw_snps_v2.vcf \
        -O filtered_snps_v2.vcf \
        -filter-name "QD_filter" -filter "QD < 2.0" \
        -filter-name "FS_filter" -filter "FS > 60.0" \
        -filter-name "MQ_filter" -filter "MQ < 40.0" \
        -filter-name "SOR_filter" -filter "SOR > 4.0" \
        -filter-name "MQRankSum_filter" -filter "MQRankSum < -12.5" \
        -filter-name "ReadPosRankSum_filter" -filter "ReadPosRankSum < -8.0" 

#Filter INDELs
$gatk --java-options "-Xmx50G" VariantFiltration \
        -R ref.fa \
        -V raw_indels_v2.vcf \
	-O filtered_indels_v2.vcf \
        -filter-name "QD_filter" -filter "QD < 2.0" \
        -filter-name "FS_filter" -filter "FS > 200.0" \
        -filter-name "SOR_filter" -filter "SOR > 10.0"


