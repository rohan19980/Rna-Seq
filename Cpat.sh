#!/usr/bin/env bash


#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=2000M
#SBATCH --time=02:00:00
#SBATCH --job-name=cpat
#SBATCH --mail-user=al.dhali@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/adhali/output/output_cpat_%j.o
#SBATCH --error=/data/users/adhali/error/error_cpat_%j.e

module add SequenceAnalysis/GenePrediction/cpat/1.2.4;
module add R/3.6.1;

READS_DIR=/data/courses/rnaseq/lncRNAs/Project2
HOME_DIR=/data/users/adhali
mkdir -p $HOME_DIR/cpat

cd $HOME_DIR/cpat

ln -s $READS_DIR/reference-files/Integrative_analysis/Human_Hexamer.tsv .
ln -s $READS_DIR/reference-files/Integrative_analysis/Human_logitModel.RData .
ln -s $HOME_DIR/kallisto/meta-assembly.fa .

# wget https://sourceforge.net/projects/rna-cpat/files/v1.2.2/prebuilt_model/Human_Hexamer.tsv
# wget https://sourceforge.net/projects/rna-cpat/files/v1.2.2/prebuilt_model/Human_logitModel.RData

cpat.py -g meta-assembly.fa -x Human_Hexamer.tsv -d Human_logitModel.RData -o cpat_output