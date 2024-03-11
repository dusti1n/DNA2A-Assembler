# rule pilon;
# The pilon rule performs genome polishing using pilon by 
# using the original racon polished contigs and aligned reads 
# and storing a polished version of the contigs.

# Input files: 
# - ../{sample}.fasta
# - ../{sample}_bwa_aligned_reads.bam

# Output files: ../{sample}_pilon.fasta

rule pilon:
    input:
        contigs="results/{project_name}/racon/{sample}.fasta",
        bam="results/{project_name}/bwa_align/{sample}_bwa_aligned_reads.bam"
    output:
        pilon_contigs="results/{project_name}/pilon/{sample}_pilon.fasta"
    conda:
        "../envs/pilon.yaml"
    log:
        "results/{project_name}/logfiles/pilon/{sample}.log"
    params:
        assembly_prefix=lambda wildcards: wildcards.sample
    threads: num_cores
    shell:
        """
        samtools index {input.bam}
        export _JAVA_OPTIONS="-Xmx{config[pilon_memory]}"
        pilon --genome {input.contigs} \
              --bam {input.bam} \
              --outdir results/{config[project_name]}/pilon/ \
              --output {params.assembly_prefix}_pilon &>> {log}
        """