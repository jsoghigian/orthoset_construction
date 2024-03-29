# ORTHOLOG SET CONSTRUCTION
Orthology prediction is critical for many genomic studies, particularly comparative genomics and phylogenomics. A variety of tools exist for identifying orthologous gene groups in nucleotide sequence data, but as the number of samples increase, the computational time necessary can become restrictive.  An alternative approach has been to define a set of orthologous groups, say from a subset of samples or from an online repository such as OrthoDB, and then use more computationally tractable solutions to match the remaining samples to those orthologous groups.  

One excellent tool for orthology prediction against an existing catalog is [Orthograph](https://github.com/mptrsen/Orthograph) ([Peterson et al. 2017](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-017-1529-8)). Orthograph uses an existing set of orthologous genes and creates am ortholog set or catalog.  Orthograph then uses a graph-based approach to identify putative orthologs from input DNA contigs, such as from gene calling programs, transcriptomes, or target capture.  Here, I present a few scripts I have written that enable rapid creation of orthologous gene sets ready for importing into Orthograph. 

For now, only tutorials involving gene sets from OrthoDB are presented. However, I have previously used gene sets from OMA, OrthoFinder2, and others, in a similar fashion - any method that outputs an orthologous gene set as a single fasta file per orthogroup should be readily customizable with the script here.

## CITATION

We have a manuscript in preparation where we demonstrate the utility of these catalogs in evaluating denovo genome sequencing data from museum specimens.  More details to come soon.

## INSTALLATION
Just place the shell scripts and python scripts in the same directory, and feel free to run them from anywhere, add them to your path, etc.  Just always keep the shell and python scripts in the same directory.

## QUICK START GUIDE FOR DOWNLOADING FROM ORTHODB
For a more detailed tutorial on the usage of these scripts, see below.

1) Run the script ortho_dl.sh to download the orthologs at the target group of interest from OrthoDB:
```sh ortho_dl.sh coloeoptera 7041 0.8 0.8```  

2) Next, parse the fasta files to adjust headers as necessary:
```sh ortho_process.sh coleoptera``` 

3) Once processed, add your new orthologs to Orthograph, or use them as a reference catalog in your own favorite software tools.  Remember to create appropriate catalogs of ortholog files.

## TUTORIAL FOR DOWNLOADING A SET OF ARACHNIDA ORTHOLOGS FROM ORTHODB
This tutorial generates a set of files and directories suitable for phylogenomic analysis, or for the creation of an ortholog catalog usable by Orthograph. It assumes you have already downloaded and installed [Orthograph](https://github.com/mptrsen/Orthograph).

This guide was written for OrthoDB version 10.1, and will hopefully be updated with additional OrthoDB versions as needed.

### IDENTIFYING TAXONOMIC ID FROM ORTHODB
This quickstart guide will walk through an example of downloading a set of orthologs for Arachnida from OrthoDB. The first step is to identify the taxonomic level from OrthoDB.  OrthoDB contains a wide range of taxonomic levels for users to choose from.  To see what levels are available, from OrthoDB, click Advanced.  This will display the list of species and taxonomic groupings available.  Ortholog sets are available for taxonomic groupings of genomes that have  a box around their name, as in this example: 
<center>
<img src="https://github.com/jsoghigian/orthoset_construction/blob/master/example/ortho_db.png?raw=trueg" style="margin:5px 5px 5px 5px"> 
</center>
Now for the steps themselves:

1) Navitage to OrthoDB.org.  **Refresh the page to clear previous searches etc from cache**. Click on Advanced to bring up the species/taxonomy selection screen, as shown above.
2) Select Arachnida by clicking the empty box next to the ID.   The number next to Arachnida indicates there are 10 genomes present in this taxonomic category.  You may need to expand Eukaryota, Metazoa, and Arthropoda before you can click Arachnida, depending on your previous browsing.  

<center>
<img src="https://github.com/jsoghigian/orthoset_construction/blob/master/arach1.png?raw=trueg" style="margin:5px 5px 5px 5px"> 
</center>

Once selected, the level Arachnida will receive a checkmark, as will all associated taxonomic levels above the order, as above.  Click the Submit button. 

3) This page contains the set of orthologs associated with Arachnida based on the default settings of the OrthoDB search.  The taxonomic ID is actually part of the URL of this page and is visible in a web browser.  We will revisit that momentarily.  With no filtering, there will be a total of 16575 orthogroups.  Click the back button to return to the previous OrthoDB page, and click Advanced. Arachnida should still be selected; if it is not, re-select it.
4) Under Phyloprofile, change the first drop down box to present in all species; I will sometimes refer to this value as the universality of the orthologs.  Change the second drop down box to single copy in >90% of species.  Click submit.
5) The set of orthologs displayed are those that are present in all Arachinda genomes on OrthoDB, *and* single copy in 90% of those genomes. The search result should list 2342 orthogroups.  For your own analyses, carefully consider universality and single copy thresholds based on your research question and methods.  Note that the number shown in the web preview will vary slightly with the number retrieved from online databases due to slight differences in inclusions, a minor issue that OrthoDB is aware of and plans to fix in the future.
6) Note the level and species ID in the URL bar, as below:

<center>
<img src="https://github.com/jsoghigian/orthoset_construction/blob/master/arach2.png?raw=trueg" style="margin:5px 5px 5px 5px"> 
</center>

Thus, our taxonomic ID for Arachnida is 6854.

### DOWNLOADING ORTHOGROUPS FOR THAT LEVEL
Given a taxonomic ID, and thresholds for universitality and single copyness, the script ortho_dl.sh will download the orthogroups as unaligned fasta files per orthogroup and store them within a subdirectory.  These fasta files are suitable for alignment and analysis, but will contain orthoDB header information instead of identifiable species epithets.  Later outputs of this pipeline will provide fasta files for alignment with recognizable species epithets.
1) While in the directory where you want your single copy orthologs to be downloaded and processed, run the orthodl script as below:

```sh ortho_dl.sh arachnida 6854 1 0.9```  

This command will retrieve the orthogroup identifiers associated with taxonomic ID 6854 that are single copy in all genomes at that level. The first argument, the prefix name, is an arbitrary identifier the user sets that will be used in this and subsequent steps to identify the particular ortholog catalog under construction.  In this case, the prefix name coleoptera is used to identify this particular set of downloads, and a subdirectory will be made called coleoptera_orthologs to store the results of this script.   See the header information in ortho_dl.sh for additional information.

This can take a while, depending on the number of orthogroups and number of reference species, and requires an active internet connection.  

2) Once the script completes, let's take a look at the contents of one of the fasta files:

```head arachnida_orthologs/2at6854.fasta```

You may notice that the fasta headers begin with a code like 6945_0:003757 . This identifies the species and gene ID in the OrthoDB database, but is not intelligible to us. We'll translate that a bit later, based on the other header information, and a translation file.
```grep ">" arachnida_orthologs/2at6854.fasta```

Note that multiple lines begin with 114398_0 ! This means that Orthogroup 2at6854 contains two genes originated in the species with ID 114398_0. As such, this file must be processed to ensure that the duplicated genes are removed, leaving only putative single copy orthologs to build our orthogroups from. It is important to keep in mind that with a single copy threshold below 1, some of the orthogroups in your analysis may have evidence of duplication events. Alternatively, it is possible some of the duplicated genes are the result of bioinformatics-related circumstances such as misassemblies. Regardless of the their origin, the processing script below will remove duplicated genes from fasta files.

### PROCESSING ORTHOGROUPS
Next we process our orthogroups to prepare them for Orthograph.  This involves: 

1) Fixing headers to be easier to read (and import to Orthograph!)
2) Removing any any species from an orthogroup with evidence of a duplication event
3) Updating the species IDs to match the actual species IDs, rather than OrthoDB's IDs
4) Making a single fasta file per species containing all single copy orthologs for that species, with headers corresponding to gene names and orthograph IDs
5) Making a TSV containing the connections between orthogroups, species, and gene names in the fasta file headers - a Cluster of Orthologous Groups (COG) file needed by Orthograph - and finally
6) Ensuring the input files we will add to Orthograph have the same number of entries in the COG file as in the fasta file for each species.

This is all accomplished by the ortho_process script, as demonstrated below:

```sh ortho_process.sh arachnida```

How did the script do?  Well, we can check it out.  Inside the arachnida_orthologs directory there should be one .faa and one .log file for each reference.  This particular version of OrthoDB has 10 Arachnida references.

```ls arachnida_orthologs/*.faa```  
```ls arachnida_orthologs/*.log```

To create the full single COG file of all taxa, type:

```cat *.log > tax_for_orthograph.cog```

And use the resulting tax_for_orthograph.cog file for importing gene and ortholog associations to Orthograph.

### CREATING AN ORTHOGRAPH ORTHOLOG DATABASE

The ortholog database is ready to be created in Orthograph!  As Orthograph requires its own installation instructions, head on over to https://github.com/mptrsen/Orthograph for details on how to install and run Orthograph, and to configure your own Ortholog database from the input files we've generated here!

