#! /usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=25000M
#SBATCH --time=30:00:00
#SBATCH --job-name=sortBam
#SBATCH --mail-user=al.dhali@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/adhali/output/output_sortBam_%j.o
#SBATCH --error=/data/users/adhali/error/error_sortBam_%j.e

module add UHTS/Analysis/samtools/1.10;

HOME_DIR=/data/users/adhali

cd $HOME_DIR/hisat2

for i in `seq 0 3`
do
    samtools sort -@ 4 -o Replicate_$(echo 3*${i} | bc).sorted.bam Replicate_$(echo 3*${i} | bc).bam
    samtools sort -@ 4 -o Replicate_$(echo 3*${i}+1 | bc).sorted.bam Replicate_$(echo 3*${i}+1 | bc).bam
    samtools sort -@ 4 -o Replicate_$(echo 3*${i}+2 | bc).sorted.bam Replicate_$(echo 3*${i}+2 | bc).bam
done

samtools merge -@ 4 Sample1.bam Replicate_0.sorted.bam Replicate_1.sorted.bam Replicate_2.sorted.bam
samtools merge -@ 4 Sample2.bam Replicate_3.sorted.bam Replicate_4.sorted.bam Replicate_5.sorted.bam
samtools merge -@ 4 Sample3.bam Replicate_6.sorted.bam Replicate_7.sorted.bam Replicate_8.sorted.bam
samtools merge -@ 4 SampleP.bam Replicate_9.sorted.bam Replicate_10.sorted.bam Replicate_11.sorted.bam
