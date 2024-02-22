def get_n50_input(wildcards):
    if config["illumina_data"]:
        return "results/{project_name}/pilon/{sample}_pilon.fasta"
    else:
        return "results/{project_name}/racon/{sample}.fasta"

# rule n50post; create an n50 statistic with the assembled genome
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