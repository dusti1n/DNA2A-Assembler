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
    shell:
        """
        gunzip -k {input.gzipped} -c > {output.unzipped} 2>> {log}
        """