####################################################
# sWGA primer design for Pf
# 	foreground: PvSal1 (v3.0/13.0) 
#	background: Human, GRCh38.p7 -- ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA_000001405.22_GRCh38.p7/GCA_000001405.22_GRCh38.p7_genomic.fna.gz
#	exclusion: Human mitochondrial DNA, NC_012920.1 (included in GRCh38.p7 above) -- http://www.ncbi.nlm.nih.gov/nuccore/251831106
#
# - Created 7/26/16
#-  Edited from Jonathan Parr for PvSal1 
# - Designs Pv sWGA primers with the following characteristics:
#		- restricted Tm range 18-30 (like Hahn paper, intended to prevent nonspecific primer binding with phi29 30C elongation temp)
#		- excluded the human mitochondrial genome entirely (Hahn only excluded primers with >3 binding sites)
#		- broadened the total number of primers in a set to 5-10 (default was 2-7, for unclear reasons -- Hahn used two sets of 7)
#		- decreased maximum number of complimentary bp in each primer to 3 (the default, vs 4 for Hahn)
#		- summary: different from Hahn by using newer human genome, excluding human mito DNA altogether, allowing more primers in a set
####################################################

ref_pv=/proj/meshnick/Genomes/PvSAL1_v13.0/PlasmoDB-13.0_PvivaxSal1_Genome.fasta
ref_human=/proj/meshnick/Genomes/Human_GRCh38/GRCh38p7_genomic.fasta
ref_human_mito=/proj/meshnick/Genomes/Human_GRCh38/NC_012920_1.fasta

# Before running this script: 
# 1) launch a minicon environment using the command line as follows: 

source activate swga_env

# 2) create symlinks for genomes into the working directory: "ln -s XXX.fasta" (from working directory)
# need to create symlinks b/c the program wants to create fasta index files and will get upset if there is already a fasta index there

###########################
# Step 1: BUILD PARAMETERS.CFG FILE (comment out when not needed -- this command only needs to be run once, in order to build the parameters.cfg file.)

# Define the foreground, background, and exclusionary genomes
# For "Pf":
swga init --fg_genome_fp PlasmoDB-13.0_PvivaxSal1_Genome_NOAAKM.fasta --bg_genome_fp Pf3D7_GRCh38.fasta --exclude_fp NC_012920_1.fasta


##### Testing to see if we can get the primers to work 
#--exclude_fp AAKM_contigs.fasta
# --bg_genome_fp Pf3D7_GRCh38.fasta 


###########################
# Step 2: COUNT ALL POSSIBLE PRIMERS (comment out after this has been completed - this command only needs to be run once, in order to build the primer_db database of all possible primer sets.)
# Finds all primer sets of k base pairs that bind >=2 times to the foreground genome (default, looks at 5-12mers)

# For "Pv" set:
swga count --exclude_threshold 3

# For "Pv_mito3x" set (same as above but allows for primers to bind human mito 3 times or less, like Hahn): 
#swga count --exclude_threshold 3


###########################
# Step 3: APPLY FILTERS (comment out after this has been completed - this command only needs to be run once, in order to filter the primers and select the 200 with lowest background binding freq.)

# Used Hahn's Tm range as above
# Note, in the past, have also had to increase the max gini coefficient from 0.6->1 -- but did not do this here
#	the Gini coefficient describes how evenly distributed the primers are across the genome (1= very uneven, 0=perfect even distribution)

swga filter --max_tm 35 --min_tm 18 --max_gini 0.7
###########################
# Step 4: FIND SETS (comment out after this has been completed - this command only needs to be run once, in order to find primer pairs that don't form primer-dimers, are otherwise compatible, and meet additional customizable criteria.)
#	Note, in the past, had to increase the max_fg_bind_dist to find primers
#  --min_bg_bind_dist default is min_bg_bind_dist = 30000
#  --max_fg_bind_dist default is max_fg_bind_dist = 36000


swga find_sets --max_size 10  --max_fg_bind_dist 40000


