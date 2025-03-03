#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Script parameters
params.reads1 = "SRR16946513_1.fastq.gz"
params.reads2 = "SRR16946513_1.fastq.gz"
// shows basic usage info to the user
log.info """\


Usage:

This pipeline uses fastp with default parameters on paired end fastq files and runs spades assembler on it.
  


The typical command for running the pipeline is as follows:
nextflow run read_assembly.nf --reads1 <readpair_1.fastq.gz> --reads2 <readpair_2.fastq.gz>

  --->>> Make sure you have the fastp and spades.py executable in your path, or run with docker.
        
  Mandatory arguments:
  --reads1                        Forward Fastq file
  --reads2                        Reverse Fastq file


"""
// uses fastp and trims the reads with default parameter
process trimreads {
  container "quay.io/biocontainers/fastp:0.23.3--h5f740d0_0"
  input:
    path reads1
    path reads2

  output:
    path "./trimmed/r1.paired.fq.gz"
    path "./trimmed/r2.paired.fq.gz"

    """
    mkdir ./trimmed
    fastp \\
          -i $reads1 -I $reads2 \\
          -o ./trimmed/r1.paired.fq.gz -O ./trimmed/r2.paired.fq.gz \\
          
    """
}
// runs spades on the output from fastp
process runSPAdes {
  container "chrishah/spades:v3.14.0"
  input:
    path "./trimmed/r1.paired.fq.gz"
    path "./trimmed/r2.paired.fq.gz"

  output:
  path "./assembly/scaffolds.fasta"

    """
    mkdir ./assembly
    which spades.py \\
          -o ./assembly \\
          --pe1-1 ./trimmed/r1.paired.fq.gz \\
          --pe1-2 ./trimmed/r2.paired.fq.gz \\
    
    """
}
// creates 2 channels to process reads1 and 2 in fastp and pipes the result to spades process for assembly.
workflow {
  def reads1_ch = Channel.fromPath(params.reads1)
  def reads2_ch = Channel.fromPath(params.reads2)
  trimreads(reads1_ch,reads2_ch) | runSPAdes 
}