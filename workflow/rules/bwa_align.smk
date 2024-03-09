# rule bwa_align;
# The rule bwa_align performs a sequence alignment operation 
# using BWA on paired-end Illumina reads against Racon-polished contigs 
# to generate a BAM file with aligned reads.

# Input files:
# - ../{sample}.fasta;
# - reads_pair_1=lambda wildcards: get_full_sample_path_illumina(wildcards.sample)[0]; .fastq files!
# - reads_pair_2=lambda wildcards: get_full_sample_path_illumina(wildcards.sample)[1]; .fastq files!

# Output files: ../{sample}_bwa_aligned_reads.bam

# The function searches a dictionary for files for a given sample and technology and generates paths to these files;
def get_full_sample_path_illumina(sample, technology="Illumina"):
    sample_files_illumina = samples[sample].get(technology, [])
    if sample_files_illumina:
        return [os.path.join(config["sample_path"], sample, "illumina", file_name) for file_name in sample_files_illumina]
    else:
        raise ValueError(f"Keine Dateien für die Probe {sample} und Technologie {technology} gefunden.")


rule bwa_align:
    input:
        contigs="results/{project_name}/racon/{sample}.fasta",
        reads_pair_1=lambda wildcards: get_full_sample_path_illumina(wildcards.sample)[0],
        reads_pair_2=lambda wildcards: get_full_sample_path_illumina(wildcards.sample)[1]
    output:
        bam="results/{project_name}/bwa_align/{sample}_bwa_aligned_reads.bam"
    conda:
        "../envs/bwa_align.yaml"
    log:
        "results/{project_name}/logfiles/bwa_align/{sample}.log"
    threads: num_cores
    shell:
        """
        bwa index {input.contigs} 2>> {log}
        bwa mem -t {threads} {input.contigs} {input.reads_pair_1} {input.reads_pair_2} \
            | samtools view -S -b -u - | samtools sort - -o {output.bam} 2>> {log}
        """