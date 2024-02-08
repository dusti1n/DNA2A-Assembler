 # rule n50post; create an n50 statistic with the assembled genome
rule n50post:
    input:
        fasta="results/{project_name}/racon/{sample}.fasta"
    output:
        stats="results/{project_name}/n50post/{sample}.txt"
    conda:
        "../envs/n50.yaml"
    log:
        "results/{project_name}/logfiles/n50post/{sample}.log"
    shell:
        """
        assembly-stats {input.fasta} > {output.stats} 2>> {log}
        """