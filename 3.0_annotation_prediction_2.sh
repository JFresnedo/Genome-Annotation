#PBS -l walltime=02:30:00
#PBS -l nodes=1:ppn=25
#PBS -N annotation_pred2
#PBS -A PAS1582

module unload xalt

cd /fs/scratch/PAS1582/osu8618/Annotation

mv maker_opts.training.ctl.snap.aug.pred2 maker_opts.ctl

export ZOE=/users/PAS0107/osu6702/project/applications/snap/Zoe # sh, bash, etc
singularity exec maker_version2.sif /usr/local/bin/maker/bin/maker -base Almond_pred2  2>maker.error

#combine all gff for each scaffold
singularity exec maker_version2.sif /usr/local/bin/maker/bin/gff3_merge -d Almond_pred2.maker.output/Almond_pred2_master_datastore_index.log

# GFF w/o the sequences
singularity exec maker_version2.sif /usr/local/bin/maker/bin/gff3_merge -n -s -d Almond_pred2.maker.output/Almond_pred2_master_datastore_index.log > Almond_pred2.all.maker.noseq.gff

mv maker_opts.ctl maker_opts.training.ctl.snap.aug.pred2
