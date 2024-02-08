# rule bioawk; create a read-length table
rule bioawk:
    input:
        fastq=lambda wildcards: get_full_sample_path(wildcards.sample) + ".fastq.gz"
    output:
        csv="results/{project_name}/csvfile/{sample}.csv"
    conda:
        "../envs/bioawk.yaml"
    log:
        "results/{project_name}/logfiles/bioawk/{sample}.log"
    shell:
        """
        echo 'sample,length' > {output.csv} 2>> {log}
        bioawk -c fastx '{{print "{wildcards.sample}," length($seq)}}' {input.fastq} >> {output.csv} 2>> {log}
        """