# rule racon; Racon polish a genome assembly using sequencing reads, improving its accuracy.
rule racon:
    input:
        trimmed_reads="results/{project_name}/porechop/{sample}.trimmed.fastq",
        assembly="results/{project_name}/assemblies/{sample}/{sample}.contigs.fasta"
    output:
        polished="results/{project_name}/racon/{sample}.fasta"
    conda:
        "../envs/racon.yaml"
    log:
        "results/{project_name}/logfiles/racon/{sample}.log"
    params:
        output_samfile="results/{project_name}/racon/mapped_reads.sam"
    shell:
        """
        minimap2 -ax map-ont {input.assembly} {input.trimmed_reads} > {params.output_samfile} 2>> {log}
        racon {input.trimmed_reads} {params.output_samfile} {input.assembly} > {output.polished} 2>> {log}
        """