#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=28
#PBS -N repeat_anno
#PBS -A PAS1582

module unload xalt

cd /fs/scratch/PAS1582/osu8618/Annotation

mkdir Almond_repeatDB
cp /fs/scratch/PAS1582/HCS7194_Files/Genome_Annotation/Almond_scaffold1.fasta .
/users/PAS0107/osu6702/project/applications/RepeatModeler-open-1.0.11/BuildDatabase -name  Almond_repeatDB/Almond_repeat -engine ncbi Almond_scaffold1.fasta
/users/PAS0107/osu6702/project/applications/RepeatModeler-open-1.0.11/RepeatModeler -pa 28 -engine ncbi -database Almond_repeatDB/Almond_repeat 2>&1 | tee repeatmodeler.log

###Mask the the genome:
#note: the default species is human, change to plant?????
#Observe .tbl output for summary of identified repeats
/users/PAS0107/osu6702/project/applications/RepeatMasker/RepeatMasker -lib RM_54946.TueSep31517542019/consensi.fa.classified Almond_scaffold1.fasta

######convert RepeatMasker OUT to GFF3, for input into MAKER
/users/PAS0107/osu6702/project/applications/RepeatMasker/util/rmOutToGFF3.pl Almond_scaffold1.fasta.out > Almond_scaffold1.fasta.out.gff3
cat Almond_scaffold1.fasta.out.gff3 | \
  perl -ane '$id; if(!/^\#/){@F = split(/\t/, $_); chomp $F[-1];$id++; $F[-1] .= "\;ID=$id"; $_ = join("\t", @F)."\n"} print $_' \
  > Almond_scaffold1.fasta.out.reformat.gff3
