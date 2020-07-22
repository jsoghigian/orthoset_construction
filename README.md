# ORTHOLOG SET CONSTRUCTION
Orthology prediction is critical for many genomic studies, particularly comparative genomics and phylogenomics. A variety of tools exist for identifying orthologous gene groups in nucleotide sequence data, but as the number of samples increase, the computational time necessary can become restrictive.  An alternative approach has been to define a set of orthologous groups, say from a subset of samples or from an online repository such as OrthoDB, and then use more computationally tractable solutions to match the remaining samples to those orthologous groups.  

One excellent tool for orthology prediction against an existing catalog is [Orthograph](https://github.com/mptrsen/Orthograph) ([Peterson et al. 2017](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-017-1529-8)). Orthograph uses an existing set of orthologous genes and creates am ortholog set or catalog.  Orthograph then uses a graph-based approach to identify orthologs in genes, contigs, or other sequence data based on this previously defined ortholog set.  Here, I present a few scripts I have written that enable rapid creation of orthologous gene sets ready for importing into Orthograph. 

For now, only tutorials involving gene sets from OrthoDB are presented. However, I have previously used gene sets from OMA, OrthoFinder2, and others, in a similar fashion - any method that outputs an orthologous gene set as a single fasta file per orthogroup should be readily customizable with the script here.

## CITATION

We have a manuscript in preparation where we demonstrate the utility of these catalogs in evaluating denovo genome sequencing data from museum specimens.  More details to come soon.

## INSTALLATION
Just place the shell scripts and python scripts in the same directory, and feel free to run them from anywhere, add them to your path, etc.  Just always keep the shell and python scripts in the same directory.

## QUICK START GUIDE FOR DOWNLOADING FROM ORTHODB
This quick start guide generates a set of files and directories suitable for phylogenomic analysis, or for the creation of an ortholog catalog usable by Orthograph. It assumes you have already downloaded and installed [Orthograph](https://github.com/mptrsen/Orthograph).

This guide was written for OrthoDB version 10.1, and will hopefully be updated with additional OrthoDB versions as needed.

### IDENTIFYING TAXONOMIC ID FROM ORTHODB
This quickstart guide will walk through an example of downloading a set of orthologs for Coleoptera from OrthoDB. The first step is to identify the taxonomic level from OrthoDB.  OrthoDB contains a wide range of taxonomic levels for users to choose from.  To see what levels are available, from OrthoDB, click Advanced.  This will display the list of species and taxonomic groupings available.  Ortholog sets are available for taxonomic groupings of genomes that have  a box around their name, as in this example: 

Now for the steps themselves:

1) Navitage to OrthoDB.org . Click on Advanced to bring up the species/taxonomy selection screen, as shown above.
2) Select Coleoptera by clicking the empty box next to the ID.   The number next to Coleoptera indicates there are 9 genomes present in this taxonomic category.  You may need to expand Eukaryota, Metazoa, Arthropoda, Hexapoda, Insecta, and Holometabola before you can click Coleoptera, depending on your previous browsing.  Once selected, the level Coleoptera will receive a checkmark, as will all associated taxonomic levels above the order.  click the submit button. 
3) This page contains the set of orthologs associated with Coleoptera based on the default settings of the OrthoDB search.  The taxonomic ID is actually part of the URL of this page and is visible in a web browser.  We will revisit that momentarily.  With no filtering, there will be a total of 11817 orthogroups.  Click the back button to return to the previous OrthoDB page, and click Advanced. Coleoptera should still be selected; if it is not, re-select it.
4) Under Phyloprofile, change the first drop down box to present in >80% of species; I will sometimes refer to this value as the universality of the orthologs.  Change the second drop down box to single copy in >80% of species.  Click submit.
5) The set of orthologs displayed are those that are present *and* single copy in more than 80% of the genomes. The search result should list 739 orthogroups.  For your own analyses, carefully consider universality and single copy thresholds based on your research question and methods.
6) Note the level and species ID in the URL bar, as below:

Thus, our taxonomic ID for Coleoptera will is 7041.

### DOWNLOADING ORTHOGROUPS FOR THAT LEVEL
Given a taxonomic ID, and thresholds for universitality and single copyness, the script ortho_dl.sh will download the orthogroups as unaligned fasta files per orthogroup and store them within a subdirectory.  These fasta files are suitable for alignment and analysis, but will contain orthoDB header information instead of identifiable species epithets.  Later outputs of this pipeline will provide fasta files for alignment with recognizable species epithets.
1) While in the directory where you want your single copy orthologs to be downloaded and processed, run the orthodl script as below:
```sh ortho_dl.sh coloeoptera 7041 0.8 0.8```  

This command will retrieve the orthogroup identifierss associated with taxonomic ID 7041 that are single copy in 80% of the genomes at that level.  The prefix name coleoptera is used to identify this particular set of downloads, and a subdirectory will be made called coleoptera_orthologs to store the results of this script.  See the header information in ortho_dl.sh for additional information.

This can take a while, depending on the number of orthogroups and number of reference species, and requires an active internet connection.  

### PROCESSING ORTHOGROUPS

### CREATING AN ORTHOGRAPH ORTHOLOG DATABASE
