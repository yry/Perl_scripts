# Perl_scripts

These scripts can be used freely, without warranties.
Regardless of the form in which this output is presented, the source must always be acknowledged.

sRNA processing folder
* read
  * script for reading a file line by line.
  * the input can be in any format
  
* fastq2fasta
  * transforms the fastq file into fasta format
  * keeps only the id and the sequence information (the quality scores are discarded)
  
* R2NR
  * transforms a file from redundant format (all reads) into non-redundant format (unique reads with their abundances)
  * ths format for the non-redundant output (NR) is >sequenceID \n sequence

* guess adapter
  * input: number of guessing nucleotides
  * all {A, C, T, G} combinations are created and used as adapter for trimming reads
  * the proposed combinations are usually shorter than the recommended length for adapter trimming
    * e.g. if the adapter trimming for sRNA files is usually done on 7, 8, 9 nt with a perfect match,then the guessing could be done at 4 or 5 nt
    * once the guessing is complete, the fragments with the highest number of hits against all reads are aligned and the correct adapter is guessted from the consensus

* removeN
  * removed the assigned high definition (HD) nucleotides used for HD sRNA-seq (Xu et al 2015)

* remove solexa adapters
  * removes the sequencing adapter for sRNA-seq input
  * it is based on a perfect match of the 5' end of the adapter, provided as parameter
  * the two versions of the script keep for further analysis either the longer (>16nt) or short (<16nt) fragments
  * the longer fragments are most likely sRNAs or degradation products
  * the shorter fragments could indicate technical issues (such as adapter-adapter dimers)
