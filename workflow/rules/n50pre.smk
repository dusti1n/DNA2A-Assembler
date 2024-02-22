# rule n50pre; create n50 statistics from the raw data
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