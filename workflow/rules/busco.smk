# rule busco; analysis
rule busco:
    input:
        "results/{project_name}/racon/{sample}.fasta"
    output:
        short_txt="results/{project_name}/busco/{sample}_short_summary.txt"
    log:
        "results/{project_name}/logfiles/busco/{sample}.log"
    params:
        mode=config["busco_mode"],
        lineage=config["busco_lineage"]
    threads: num_cores
    wrapper:
        "v3.3.6/bio/busco"