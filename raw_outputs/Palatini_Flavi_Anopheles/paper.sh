#!/bin/env bash

# Anopheles accession numbers
accessions=("APHL01" "ALPR02" "AAAB01" "ACXO01" "APCH01" "APCJ01" "APCL01" "APCN01" "ATLV01" "AXCK02" "AXCM01" "JXXA01" "ABKP02" "AXCN01" "ADMH02" "APCG01" "APCI01" "APCK01" "APCM01" "APHL01" "ATLZ01" "AXCL01" "AXCP01" "JXXB01") # 24 samples
#SAMPLE=("AAAB01")
#alias python=/usr/bin/python2.7

export PATH="/media/nbrait/Data/EVE_PIPELINE/Palatini/dependencies/refine_eves:${PATH}"
export PATH="/media/nbrait/Data/EVE_PIPELINE/Palatini/dependencies/Scripts/EVEfinder/EVE_finder:${PATH}"
export PATH="/media/nbrait/Data/EVE_PIPELINE/Palatini/dependencies/vhost_classifier:${PATH}"
export PATH="/home/nbrait/.taxonkit:${PATH}"
export PATH="/home/nbrait:${PATH}"
#export PATH="/usr/bin:$PATH"

for SAMPLE in "${accessions[@]}"; do

cd /media/nbrait/Data/EVE_PIPELINE/Palatini/detectEVE

# blast search
    blastx -query "./SAMPLES/${SAMPLE}.1.fa" -db "Flavi.fasta" -evalue 1e-3 -num_threads 16 \
    -outfmt '6 qseqid qstart qend salltitles evalue qframe pident qcovs sstart send slen' \
    -out "./ANALYSIS/${SAMPLE}_target.blastx" ## changing evalue back to e-6!!!!!!!!!!!!!

# Execute Blast_to_Bed3.py
    cd /media/nbrait/Data/EVE_PIPELINE/Palatini/detectEVE/ANALYSIS
    python2.7 /media/nbrait/Data/EVE_PIPELINE/Palatini/dependencies/Scripts/EVEfinder/EVE_finder/Blast_to_Bed3.py ${SAMPLE}_target.blastx

# Sort the bed file
    bedtools sort -i ${SAMPLE}_target_EVEs.bed > ${SAMPLE}.sorted.bed

# Merge overlapping intervals
    bedtools merge -i ${SAMPLE}.sorted.bed -c 4,5,6,7,8,9,10,11 -o collapse,collapse,distinct,collapse,collapse,collapse,collapse,collapse > ${SAMPLE}.merged.bed

# Execute Top_score_BED2.py
    python2.7 /media/nbrait/Data/EVE_PIPELINE/Palatini/dependencies/Scripts/EVEfinder/EVE_finder/Top_score_BED2.py ${SAMPLE}.merged.bed ${SAMPLE}_top.bed

# Extract sequences using bedtools getfasta
    bedtools getfasta -s -name -fi ../SAMPLES/${SAMPLE}.1.fa -bed ${SAMPLE}_top.bed -fo ${SAMPLE}_top.fasta

# retrosearch diamond
    diamond blastx -d /media/nbrait/Data/EVE_PIPELINE/Palatini/database/nr_diamond -e 1e-03 --threads 16 -f6 \
    qseqid qstart qend salltitles evalue qframe pident qcovhsp sstart send slen staxids -q ${SAMPLE}_top.fasta -o ${SAMPLE}Top_nr.blastx

# Execute Refine_EVE_Annotation.sh script
    bash Refine_EVE_Annotation.sh \
        -pipeline_directory /media/nbrait/Data/EVE_PIPELINE/Palatini/dependencies/refine_eves/ \
        -reverse_blast_tool diamond \
        -VHC_directory /media/nbrait/Data/EVE_PIPELINE/Palatini/dependencies/vhost_classifier \
	-file_blastx "/media/nbrait/Data/EVE_PIPELINE/Palatini/detectEVE/ANALYSIS/${SAMPLE}Top_nr.blastx" \
        -file_bed_tophit "/media/nbrait/Data/EVE_PIPELINE/Palatini/detectEVE/ANALYSIS/${SAMPLE}_top.bed" \
        -output_directory "/media/nbrait/Data/EVE_PIPELINE/Palatini/detectEVE/RESULTS/evalue/${SAMPLE}_output" \
        -taxonkit_exe "/media/nbrait/Data/EVE_PIPELINE/Palatini/detectEVE/taxonkit"
done

