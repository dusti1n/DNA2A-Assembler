# rule busco; WRAPPER was used!
# The rule busco performs BUSCO for quality assessment of 
# genome assemblies using either pilonized or racon-polished 
# fasta files as input, depending on whether Illumina data is available, 
# and stores the results in a short summary file.

# Input files: get_busco_input; .fasta files!
# Output files: ../{sample}_short_summary.txt

# The function get_busco_input determines the input path for BUSCO based on whether Illumina data is available and selects a pilonized or racon-polished Fasta file accordingly.
def get_busco_input(wildcards):
    if config["illumina_data"]:
        return "results/{project_name}/pilon/{sample}_pilon.fasta"
    else:
        return "results/{project_name}/racon/{sample}.fasta"


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