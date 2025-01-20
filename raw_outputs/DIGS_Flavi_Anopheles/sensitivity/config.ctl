Begin SCREENDB;
	 db_name=Anopheles_sensitivity;
	 mysql_server=localhost;
  ENDBLOCK;

  BEGIN SCREENSETS;
	  query_aa_fasta=/media/nbrait/Data/EVE_PIPELINE/DIGS_NEW/FLAVI_ANOPHELES/Flavi_cut.fa;
	  reference_aa_fasta=/media/nbrait/Data/EVE_PIPELINE/DIGS_NEW/FLAVI_ANOPHELES/Flavi_cut.fa;
	  bitscore_min_tblastn=60;
	  output_path=/media/nbrait/Data/EVE_PIPELINE/DIGS_NEW/sensitivity/;
	  seq_length_minimum=50;
	  defragment_range=10;
	  fwd_num_threads=40;
          rev_num_threads=40;
          #consolidate_range=3000;
          #consolidated_reference_aa_fasta=/media/nbrait/Data/EVE_PIPELINE/DIGS/Flavivirus/flavi-references-virus.faa;
	  #query_na_fasta=/home/rob/DIGS/projects/lenti-probes.fna
	  #reference_na_fasta=/home/rob/DIGS/projects/lenti-probes.fna
	  #bitscore_min_blastn=30;
  ENDBLOCK;

  BEGIN TARGETS;
	  insects/Anopheles/assembly/sensitivity/
  ENDBLOCK;
  
