# rule n50post;
# The n50post rule calculates statistical values such as N50 
# for genome assemblies that are either piloted or 
# racon-polished and stores the results in a text file.

# Input files: fasta=get_n50_input; .fasta files!
# Output files: ../{sample}.txt

# The function get_n50_input determines the input fasta file for the N50 calculation, depending on whether Illumina data is used, and selects a pilonized or racon-polished file accordingly.
def get_n50_input(wildcards):
    if config["illumina_data"]:
        return "results/{project_name}/pilon/{sample}_pilon.fasta"
    else:
        return "results/{project_name}/racon/{sample}.fasta"


rule n50post:
    input:
        fasta=get_n50_input
    output:
        stats="results/{project_name}/n50post/{sample}.txt"
    conda:
        "../envs/n50post.yaml"
    log:
        "results/{project_name}/logfiles/n50post/{sample}.log"
    shell:
        """
        assembly-stats {input.fasta} > {output.stats} 2>> {log}
        """