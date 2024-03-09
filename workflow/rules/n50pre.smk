# rule n50pre;
# The n50pre rule calculates statistical values such as N50 
# for unprocessed (raw) FastQ files and saves the results in a text file.

# Input files: ../{sample}.fastq
# Output files: ../{sample}.txt

rule n50pre:
    input:
        fastqgz="results/{project_name}/temp/{sample}.fastq"
    output:
        stats="results/{project_name}/n50pre/{sample}.txt"
    conda:
        "../envs/n50pre.yaml"
    log:
        "results/{project_name}/logfiles/n50pre/{sample}.log"
    shell:
        """
        assembly-stats {input.fastqgz} > {output.stats} 2>> {log}
        """