# rule porechop; remove the adapter sequences
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