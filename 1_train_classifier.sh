#PBS -l walltime=36:00:00
#PBS -l nodes=1:ppn=25
#PBS -N annotation_mpi_round1_BC
#PBS -A PAS1582

module unload xalt

cd /fs/scratch/PAS1582/osu8618/Annotation_Class

mv maker_opts.training.ctl.round1 maker_opts.ctl

export ZOE=/fs/scratch/PAS1582/HCS7194_Files/Genome_Annotation/bin/snap/Zoe # sh, bash, etc
module load singularity
singularity exec maker_version2.sif  /usr/local/bin/maker/bin/maker -base Almond_BC_rnd1  2>maker.error

#combine all gff for each scaffold
singularity exec maker_version2.sif /usr/local/bin/maker/bin/gff3_merge -d Almond_BC_rnd1.maker.output/Almond_BC_rnd1_master_datastore_index.log

# GFF w/o the sequences
singularity exec maker_version2.sif /usr/local/bin/maker/bin/gff3_merge -n -s -d Almond_BC_rnd1.maker.output/Almond_BC_rnd1_master_datastore_index.log > Almond_BC_rnd1.all.noseq.gff

#create some additional gff files to use for the first round of snap training/prediction:
cat Almond_BC_rnd1.all.noseq.gff | awk '{if($2=="protein2genome")print $0}' > Almond_BC_rnd1.all.protein2genome.gff

##NOTE: HOW DO REPEATS BELLOW DIFFER FROM THE OTHER REPEATS??????
cat Almond_BC_rnd1.all.noseq.gff | awk '{if($2=="repeatrunner")print $0}' > Almond_BC_rnd1.all.repeats.gff
cat Almond_BC_rnd1.all.noseq.gff | awk '{if($2=="est2genome")print $0}' > Almond_BC_rnd1.all.est2genome.gff
mv maker_opts.ctl maker_opts.training.ctl.round1
