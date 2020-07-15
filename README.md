# ORTHOLOG SET CONSTRUCTION
Orthology prediction is critical for many genomic studies, particularly comparative genomics and phylogenomics. A variety of tools exist for identifying orthologous gene groups in nucleotide sequence data, but as the number of samples increase, the computational time necessary can become restrictive.  An alternative approach has been to define a set of orthologous groups, say from a subset of samples or from an online repository such as OrthoDB, and then use more computationally tractable solutions to match the remaining samples to those orthologous groups.  

One excellent tool for orthology prediction against an existing catalog is [Orthograph](https://github.com/mptrsen/Orthograph) ([Peterson et al. 2017](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-017-1529-8)). Orthograph uses an existing set of orthologous genes and creates a set that can be identified in genes, contigs, or other sequence data.  Here, I present a few scripts I have written that enable rapid creation of orthologous gene sets ready for importing into Orthograph. 

For now, only tutorials involving gene sets from OrthoDB are presented. However, I have previously used gene sets from OMA, OrthoFinder2, and others, in a similar fashion - any method that outputs an orthologous gene set as a single fasta file per orthogroup should be readily customizable with the script here.

## CITATION

We have a manuscript in preparation where we demonstrate the utility of these catalogs in evaluating denovo genome sequencing data from museum specimens.  More details to come soon.

## QUICK START GUIDE FOR DOWNLOADING FROM ORTHODB
To Be Written
