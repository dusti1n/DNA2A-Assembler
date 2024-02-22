def get_busco_input(wildcards):
    if config["illumina_data"]:
        return "results/{project_name}/pilon/{sample}_pilon.fasta"
    else:
        return "results/{project_name}/racon/{sample}.fasta"

# rule busco; analysis
rule busco:
    input:
        get_busco_input
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