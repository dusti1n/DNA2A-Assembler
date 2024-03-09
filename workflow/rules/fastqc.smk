# rule fastqc;
# The fastqc rule performs a quality check of .fastq files and creates HTML and ZIP reports with FastQC.

# Input files: ../{sample}.fastq

# Output files:
# - html="results/{project_name}/fastqc/{sample}/{sample}_fastqc.html";
# - zip="results/{project_name}/fastqc/{sample}/{sample}_fastqc.zip";

rule fastqc:
    input:
        fastq="results/{project_name}/temp/{sample}.fastq"
    output:
        html="results/{project_name}/fastqc/{sample}/{sample}_fastqc.html",
        zip="results/{project_name}/fastqc/{sample}/{sample}_fastqc.zip"
    conda:
        "../envs/fastqc.yaml"
    log:
        "results/{project_name}/logfiles/fastqc/{sample}.log"
    params:
        assembly_prefix=lambda wildcards: wildcards.sample,
        fastqc_memory=config["fastqc_memory"]
    threads: num_cores
    shell:
        """
        fastqc {input.fastq} --outdir=results/{config[project_name]}/fastqc/{params.assembly_prefix} --memory {params.fastqc_memory} &>> {log}
        touch {output.html} {output.zip}
        """