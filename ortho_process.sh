#!/bin/bash

#This script is part of the ortholog construction pipeline written by J. Soghigian.
#It was last edited on 7/13/2020
#This script will take previously downloaded fasta sequences from OrthoDB and prepare them for input to Orthograph.
#It requires python 3 and biopython.
#Note that this script refers to odb10v1.species.list.txt . This file could need to be changed if the odb version updates and new genomes are added.
#In addition, this script attempts to dynamically find the location of the python helper scripts, split.py and fasta_uniqueonly_by_id.py . It assumes they are stored in the same directory as the script.  Please note that you can modify the SCRIPTPATH variable below should you wish to store those scripts elsewhere.
#Usage:
#sh ortho_process.sh prefix_name
#Make sure to specify the same prefix name as used during ortho_dl.  This prefix is essential for running the script correctly.

#Example:
#sh ortho_process.sh diptera

#Store the path to the ortho_process  script; we assume our python scripts and naming file are in the same location.
SCRIPTPATH="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"

ogprefix=$1

cd ${ogprefix}_orthologs

#We will start with modifying the fasta files we downloaded, then creating directories for each reference species that contain the orthologs we'll later use for ortholog identification through Orthograph's ortholog catalog.  These steps allow us to also do things like aligning orthologs and building trees from the reference catalog. 

#Now we will make a directory called sco, where we will store our modified single copy orthologs - this keeps the original downloaded files intact in case something breaks along the way and we need to start over. Then, we fix up the headers a little - mostly because the headers out of orthodb are long and can make sorting and manipulating difficult.  Finally, we remove any fasta sequence with a "duplicate ID", meaning any gene duplicates are removed entirely from fasta file and will not be processed for ortholog set creation.  It is important to note that any single copy ortholog that makes it into our ortholog catalog will be at least 90% single copy across the taxonomic level we specified. 
echo Creating directories for orthologs...
mkdir sco
mkdir raw_inputs
mv *.fasta raw_inputs/
#note that if you have too many orthologs, you will need to change this search statement to one with find, like below.
cd raw_inputs/
echo Fixing ortholog headers, moving orthologs to a working directory
for file in `find . -name '*.fasta'`;
do
ortho=$(basename $file .fasta);
sed 's/\:/\ /g' $file > fix_${ortho}.fasta
python3 ${SCRIPTPATH}/fasta_uniqueonly_by_id.py fix_${ortho}.fasta > ../sco/sco_${ortho}.fasta
rm fix_${ortho}.fasta
done

cd ..

#next, we are going to make a directory for each species that we have orthologs for.  We started in the sco directory, then use a python script to split each one.  We start by making a directory to hold all those directories, called taxa.

echo Creating a directory for each species and placing corresponding orthologs within the directory...
mkdir taxa
cd sco
echo Updating orthoDB IDs to species IDs from the odb11v1_species.tab list ...
for file in `find . -name '*.fasta'`;
do
  orthogroup=$(basename ${file} .fasta)
  mkdir $orthogroup
  cp $file ${orthogroup}/
  cd $orthogroup
  python3 ${SCRIPTPATH}/split.py -f $file -t faa
  rm $file
  for ortho_file in `ls *.faa`;
  do
    taxa=$(basename ${ortho_file} .faa)
    tax_name=$(grep -w $taxa ${SCRIPTPATH}/odb11v0_species.tab | awk -F " " '{ print $3 }')
    mkdir ../../taxa/$tax_name 2> /dev/null
    cp $ortho_file ../../taxa/$tax_name/${orthogroup}.faa
  done
  cd ..
done

#3) CREATE THE FILES NECESSARY FOR ORTHOLOG CATALOG CONSTRUCTION IN ORTHOGRAPH

#Now we will move on to ortholog catalog creation.  First, a bit of what Orthograph needs.
#in order to prepare for Orthograph, we will need to have the following:


#our fasta files are one per ortholog, e.g:
#OG2.faa
#>Culex-quinquefasciatus-Johannesburg_PEPTIDES_CpipJ2_4|CPIJ002358.faa
#MDEKINLPCTPLRAIGEEGKPATIVDFQESYSAVEDQTGYISVQVEGNPAPTWKFFKNITELVDGGRYKHHTDGESNTITLCIRKVKPNDEGKYR...

#and a tsv in the format of:
#ORTHOLOGID GENEID TAXANAME
#this is called a cluster of orthologous groups file, or cog file.

#now we will move across the taxa directories, and create a cog file for input in to Orthograph
#then we go into the taxa folder and work on each to create the proper Orthograph inputs.
echo Creating the ortholog catalog input files

cd ../taxa

for dir in $(ls -d *);
do
  cd $dir
  for file in `find . -name '*.faa'`;
  do
    orthogroup=$(basename ${file} .faa)
    taxID=$(basename $dir)
    printf ${orthogroup}'\t'${orthogroup}_${taxID}'\t'${taxID}'\n' >> ../../cog_${taxID}.log
  done
  cd ..
done
#next let's combine the fasta files and fix the headers, then add them to the parent directory.  We will have a file specifying the ortholog ids (cog file).  This cog file contains the references for the fasta header, ortholog ID, and species for all references we will build our catalog from.  We will also create a corresponding fasta file containing the orthologs, per species.  We check each to make sure they contain the same number of orthologs.
echo Make sure the number of orthologs is the same as the genes in the cog file - they confirm that the orthograph input files were created successfully.
for dir in $(ls -d *);
do
  cd $dir
  base=$(basename $dir)
  for f in *.faa; do
  ortho=$(basename $f .faa)
  perl -pi -e 's/^>(.*)/>'"${ortho}"'_'"${base}"'/' $f
  (cat "${f}";echo)>>../../${base}.faa;done
  cd ..
  num_orthos=$(grep -c ">" ../${base}.faa)
  cog_file=$(cat ../cog_${base}.log | wc -l)
  echo $base has $num_orthos orthologs and $cog_file genes in the cog file
done
