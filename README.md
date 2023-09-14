#  Broken String Biosciences Bioinformatician pre-interview coding test

The purpose of this exercise is for you to process some of the outputs of an INDUCE-seq sequencing run in order to describe and interpret the number of breaks that occur at specific sites in the genome

## Introduction

Our patented [INDUCE-seq technology](https://www.nature.com/articles/s41467-022-31702-9) reveals the precise position and frequency of DNA double strand breaks (DSBs) throughout the genome. This approach is unique as it accurately represents DNA break events in true proportions and without experimentally introduced bias. Each read represents a single DSB that has occurred in situ in the cells that have been processed. We can locate where the break has occurred by mapping the read to the human genome. The sequence of the read is not important apart for a mechanism to locate the break. Instead the 5’ end of the read is the exact position where the DSB was labelled.  

As an internal control we often use the well-characterised DIvA (DSB Inducible via AsiSI) cell line, in which treatment with 4-hydroxytamoxifen (4OHT) triggers nuclear localisation of the AsiSI enzyme. This results in DSBs occurring at the AsiSI restriction enzyme sites within the genome. However only a proportion of the approximately 1400 possible AsiSI cut sites predicted by presence of the GCGAT/CGC sequence are actually cut, primarily due to the chromatin state at each possible site.  

Fastqs files were derived from an INDUCE-seq experiment with 16 samples where a proportion of the samples are controls derived from DIvA cells without treatment, and the remainder are DIvA cells that have been treated with 4OHT. Given that INDUCE-seq determines breaks in an unbiased way, the reads representing breaks will be derived from naturally occurring endogenous breaks, in addition to those that are induced by the AsiSI enzyme active only in treated samples. The hypothesis is that treated samples can be distinguished from controls based on the number of breaks occurring at predicted AsiSI sites.  

## Starting Data
 In order to keep the size of the fastqs small and the computation tractable, the reads were down-sampled and filtered to only include those that belong to chr21.
## Starting Data
These fastq files were processed to 
1.	Map the reads to chromosome 21
2.	Convert the position of the reads contained in the bam files to genomic intervals stored in a bed file.
3.	Process the bed file so that the coordinates are adjusted to include **just** the break site. The outputs from this process are stored in [breaks](data/breaks/) 

In order to count the number of breaks occuring at AsiSI sites on chr21 in each sample they can be intersected with a bed file that contains the positions of AsiSI sites on chromsome 21: [chr21_AsiSI_sites.t2t.bed](data/chr21_AsiSI_sites.t2t.bed)

## Instructions
In a workflow manager of your choice write a pipeline to process each sample in parallel
1. ** Filter out reads that have a mapping quality of < 30 **
   Use python code to read in the sample bed file and use a generator to yield only those lines where the count at an AsiSI site > 1

**Intersect each sample break bed file with the AsiSI site bed file**
   This should be parallelised so that each samples initiates its own process. Run this operation so as to count the number of breaks at each site
2. **Sum and normalise the counts** 
   Chain the previous process to another process that takes the output from 1 and uses python and python libraries code to perform the following
   1. Read in the output file from the previous step and use a generator to yield only those lines where the count at an AsiSI site > 1

    1. **Sum the number of AsiSI breaks**  
        Each sample will contain zero or more breaks at each of the sites on chr21. Find the sum of the AsiSI breaks per sample.
    2. **Normalize the number of AsiSI breaks**  
      The initial break bed file for each sample will contain the total number of breaks per sample. In order to account for different amounts of starting material, divide the sum of AsiSI breaks (step 2.1) by (total breaks/1000), so that the data consists of the normalised sum AsiSI breaks for each sample.
3. **Collect normalised number of AsiSI breaks**
   If you have time collect and combine all these outputs into a single file withiin nextflow.

**Plot the data**
Take the pipeline outputs and plot the data so that it is possible to determine if there are clusters of samples representing control and treated subsets.

## Questions
1.	Which of the samples are likely to be controls or treated?
2.	Are there any you are uncertain of?
3.	Can you explain the samples in the uncertain group?
4.	What is the maximum percentage of possible AsiSI cut sites on chromosome 21 (as described in the chr21_AsiSI_sites.t2t.bed file) observed in a single sample?

## Result submission
Please submit your answer and code to a publicly available git repository
