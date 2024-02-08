# rule canu; genome assembling
rule canu:
    input:
        reads="results/{project_name}/porechop/{sample}.trimmed.fastq"
    output:
        assembly="results/{project_name}/assemblies/{sample}/{sample}.contigs.fasta"
    conda:
        "../envs/canu.yaml"
    log:
        "results/{project_name}/logfiles/canu/{sample}.log"
    params:
        assembly_prefix=lambda wildcards: wildcards.sample,
        canu_genome_size=config["canu_genome_size"],
        canu_minInputCoverage=config["canu_minInputCoverage"],
        canu_stopOnLowCoverage=config["canu_stopOnLowCoverage"],
        canu_grid=config["canu_grid"]
    threads: num_cores
    shell: 
        """
        canu -p {params.assembly_prefix} \
             -d results/{config[project_name]}/assemblies/{params.assembly_prefix}/ \
             -nanopore-raw {input.reads} \
             minInputCoverage={params.canu_minInputCoverage} \
             stopOnLowCoverage={params.canu_stopOnLowCoverage} \
             genomeSize={params.canu_genome_size} 2>> {log}
        """