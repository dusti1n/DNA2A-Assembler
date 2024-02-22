rule bwa_align:
    input:
        contigs="results/{project_name}/racon/{sample}.fasta",
        reads_pair_1=config["reads_pair_1"],
        reads_pair_2=config["reads_pair_2"]
    output:
        bam="results/{project_name}/bwa_align/{sample}_bwa_aligned_reads.bam"
    conda:
        "../envs/bwa_align.yaml"
    log:
        "results/{project_name}/logfiles/bwa_align/{sample}.log"
    threads: num_cores
    shell:
        """
        bwa index {input.contigs} 2>> {log}
        bwa mem -t {threads} {input.contigs} {input.reads_pair_1} {input.reads_pair_2} \
            | samtools view -S -b -u - | samtools sort - -o {output.bam} 2>> {log}
        """