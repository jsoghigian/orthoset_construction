#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
echo $SCRIPTPATH
#This script is part of the ortholog construction pipeline written by J. Soghigian.
#It was last edited on 2023-02-28
#This script will download all the fasta files belonging to a taxonomic level that meets user-specified thresholds of inclusion for universality and single-copy nature.  
#Usage:
#sh ortho_dl.sh prefix_name level universality level_of_single_copy
#Prefix name refers to the prefix used in downloading and construction of folders, and can be a name of the taxonomic group of group, e.g. Diptera.  Level refers to the internal taxonomic identifier used by orthodb, e.g. 7147 for Diptera.  Universailty is the presence of the ortholog across the genomes on orthodb at that taxonomic level, and level of single copy refers to orthologs that are single copy in only that percentage of genomes. In other words,
#sh ortho_dl.sh diptera 7147 0.9 0.9
#Will include only orthologs found in 90% of the Diptera genomes, and of those, we include only orthologs that are single copy in at least 90% of genomes.  It is important to note that this WILL download duplicated genes (we take care of them later).  The set will have the prefix diptera.

#First, we will define some variables.  We will start with the ortholog database prefix.  This is the ortholog set name we might use later for e.g. Orthograph, but the exact name is arbitrary.
ogprefix=$1

#We will now use wget to download a list of fasta file IDs for a given taxonomic level (level=7147) and species/set of species (7147).  Consider adjusting the universal/single copy settings as desired - here, universality (presence in genomes) is set to 0.9, and threshold for single copy is also set to 0.9.  This means that of all the genomes at this taxonomic level, we include only orthologs found in 90% of the genomes, and of those, we include only orthologs that are single copy in at least 90% of genomes.  It is important to note that this WILL download duplicated genes (we take care of them later).
#note if you are targetting a set of orthologs >10k, you'll need to adjust the limit we set as well.
level=$2
uni=$3
sc=$4

curl -o ${ogprefix}.uni0.9single0.9.fasta "https://data.orthodb.org/current/search?query=&level=${level}&species=${level}&universal=${uni}&singlecopy=${sc}&take=100000"
#We will now process this file so that it can be fed into a loop.  This will allow us to download each fasta file individually for each ortholog.

cat ${ogprefix}.uni0.9single0.9.fasta | awk -F"[" '{print $2}' | awk -F"]" '{print $1}' | sed 's/"//g' | perl -pe 's/, /\n/g' > ${ogprefix}.listoffasta

#This is now a file that contains OrthoDB IDs for orthologs at a given taxonomic level.  E.g., 10359at7203 is Orthogroup 10359 at taxononimc level 7203. This list corresponds to the specifications we used in the wget expression above; e.g., the orthogroups contained herein are present in 90% of genomes at that taxonimic level and 90% single copy in those genomes.  So with this identifier, we can now download this orthogroup as a fasta file.

#to begin we create a folder to store these orthologs

mkdir ${ogprefix}_orthologs

#now we loop over the aforementioned list of fasta file and download each orthogroup's fasta file.  Note that this URL may change as orthoDB changes their URLs.  Consult orthoDB for more information.

for line in `cat  ${ogprefix}.listoffasta`; do curl 'https://data.orthodb.org/current/fasta?id='"${line}"'&species='all'' -o  ${ogprefix}_orthologs/${line}.fasta; sleep 2;done

rm ${ogprefix}.listoffasta
rm ${ogprefix}.uni0.9single0.9.fasta
