# rule porechop;
# The porechop rule uses porechop to remove adapter sequences 
# and quality filter raw data from nanopore sequencing operations to generate trimmed FastQ files.

# Input files: ../{sample}.fastq
# Output files: ../{sample}.trimmed.fastq

rule porechop:
    input:
        fastq="results/{project_name}/temp/{sample}.fastq"
    output:
        trimmed_fastq="results/{project_name}/porechop/{sample}.trimmed.fastq"
    conda:
        "../envs/porechop.yaml"
    log:
        "results/{project_name}/logfiles/porechop/{sample}.log"
    shell:
        """
        porechop -i {input.fastq} -o {output.trimmed_fastq} &>> {log}
        """