# rule multiqc;
# The multiqc rule aggregates quality control reports 
# from FastQC for all samples and creates a comprehensive multiQC report as an HTML file.

# Input files: ../{sample}_fastqc.html
# Output files: html="results/{project_name}/multiqc/multiqc_report.html"

rule multiqc:
    input:
        expand("results/{project_name}/fastqc/{sample}/{sample}_fastqc.html", project_name=config['project_name'], sample=samples)
    output:
        html="results/{project_name}/multiqc/multiqc_report.html"
    conda:
        "../envs/multiqc.yaml"
    log:
        "results/{project_name}/logfiles/multiqc/multiqc.log"
    shell:
        """
        multiqc results/{config[project_name]}/fastqc/ -o results/{config[project_name]}/multiqc/ &>> {log}
        """