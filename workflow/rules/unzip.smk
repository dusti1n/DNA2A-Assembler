# rule unzip; unzip the fastq.gz files
rule unzip:
    input:
        gzipped=lambda wildcards: get_full_sample_path(wildcards.sample) + ".fastq.gz"
    output:
        unzipped=temp("results/{project_name}/temp/{sample}.fastq")
    conda:
        "../envs/unzip.yaml"
    log:
        "results/{project_name}/logfiles/unzip/{sample}.log"
    threads: num_cores
    shell:
        """
        pigz -d -c {input.gzipped} > {output.unzipped} 2>> {log}
        """