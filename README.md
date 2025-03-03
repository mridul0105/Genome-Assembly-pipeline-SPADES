# Nextflow pipeline for QC processing on fastQ files followed by assembly using SPADES
Usage:

This pipeline uses fastp with default parameters on paired end fastq files and runs spades assembler on it.
  

The typical command for running the pipeline is as follows:
nextflow run read_assembly.nf --reads1 <readpair_1.fastq.gz> --reads2 <readpair_2.fastq.gz>

  --->>> Make sure you have the fastp and spades.py executable in your path, or run with docker.
        
  Mandatory arguments:
  --reads1                        Forward Fastq file
  --reads2                        Reverse Fastq file
