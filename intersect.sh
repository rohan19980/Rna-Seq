#!/usr/bin/env bash


#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=1000M
#SBATCH --time=00:05:00
#SBATCH --job-name=Intersect
#SBATCH --mail-user=al.dhali@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/adhali/output/output_intersect_%j.o
#SBATCH --error=/data/users/adhali/error/error_intersect_%j.e

module add UHTS/Analysis/BEDTools/2.29.2;
module add Utility/UCSC-utils/359;

READS_DIR=/data/courses/rnaseq/lncRNAs/Project2
HOME_DIR=/data/users/adhali
mkdir -p $HOME_DIR/intersect
cd $HOME_DIR/intersect

ln -s $READS_DIR/reference-files/Integrative_analysis/hg19.cage_peak_phase1and2combined_coord.bed cage_peak.bed
ln -s $READS_DIR/reference-files/Integrative_analysis/hg19ToHg38.over.chain.gz .
ln -s $READS_DIR/reference-files/Integrative_analysis/atlas.clusters.2.0.GRCh38.96.bed polyAsite.bed
ln -s $READS_DIR/reference-files/gencode.v35.chr_patch_hapl_scaff.annotation.gtf gencode.gtf
ln -s $HOME_DIR/StringTie/meta-assembly_transcripts.gtf .

MARGIN=50

# 5' end cage peaks

liftOver cage_peak.bed hg19ToHg38.over.chain.gz cage_peak_hg38.bed unMapped
sed -i -e 's/\s/\t/g' cage_peak_hg38.bed
sed -i -e 's/chrM/MT/' cage_peak_hg38.bed
sed -i -e 's/chr//' cage_peak_hg38.bed

awk -v delta=$MARGIN '{if($4>delta){print $1,$4-delta,$4+delta,"NA","NA",$7,$12}}' meta-assembly_transcripts.gtf > meta-assembly_5end.bed
sed -i -e 's/\s/\t/g' meta-assembly_5end.bed
sed -i -e 's/chrM/MT/' meta-assembly_5end.bed
sed -i -e 's/chr//' meta-assembly_5end.bed
sed -i -e 's/\"//g' meta-assembly_5end.bed
sed -i -e 's/;//g' meta-assembly_5end.bed

bedtools intersect -s -u -a meta-assembly_5end.bed -b cage_peak_hg38.bed > cage_peak_intersect.txt

# 3' end polyA sites

sed -i -e 's/\s/\t/g' polyAsite.bed
sed -i -e 's/chrM/MT/' polyAsite.bed
sed -i -e 's/chr//' polyAsite.bed

awk -v delta=$MARGIN '{print $1,$5-delta,$5+delta,"NA","NA",$7,$12}' meta-assembly_transcripts.gtf > meta-assembly_3end.bed
sed -i -e 's/\s/\t/g' meta-assembly_3end.bed
sed -i -e 's/chrM/MT/' meta-assembly_3end.bed
sed -i -e 's/chr//' meta-assembly_3end.bed
sed -i -e 's/\"//g' meta-assembly_3end.bed
sed -i -e 's/;//g' meta-assembly_3end.bed

bedtools intersect -s -u -a meta-assembly_3end.bed -b polyAsite.bed > polyAsite_intersect.txt

# Intergenic

awk '{print $1,$4,$5,"NA","NA",$7}' gencode.gtf > gencode.bed
sed -i -e 's/\s/\t/g' gencode.bed
sed -i -e 's/chrM/MT/' gencode.bed
sed -i -e 's/chr//' gencode.bed


awk '{print $1,$4,$5,"NA","NA",$7,$12}' meta-assembly_transcripts.gtf > meta-assembly_transcripts.bed
sed -i -e 's/\s/\t/g' meta-assembly_transcripts.bed
sed -i -e 's/chrM/MT/' meta-assembly_transcripts.bed
sed -i -e 's/chr//' meta-assembly_transcripts.bed
sed -i -e 's/\"//g' meta-assembly_transcripts.bed
sed -i -e 's/;//g' meta-assembly_transcripts.bed

bedtools intersect -v -s -a meta-assembly_transcripts.bed -b gencode.bed > Intergenic_intersect.txt

