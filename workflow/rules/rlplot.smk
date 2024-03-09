# rule rlplot;
# The rlplot rule creates a read-length plot as a PDF file for each sample based on a CSV file, using an R script.

# Input files: ../{sample}.csv
# Output files: ../{sample}.pdf

rule rlplot:
    input:
        csv="results/{project_name}/csvfile/{sample}.csv"
    output:
        plot="results/{project_name}/rlplot/{sample}.pdf"
    conda:
        "../envs/rplot.yaml"
    log:
        "results/{project_name}/logfiles/rlplot/{sample}.log"
    shell:
        """
        Rscript workflow/scripts/readlengthplot.R {input.csv} {output.plot} {wildcards.sample} 2>> {log}
        """