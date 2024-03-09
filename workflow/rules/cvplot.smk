# rule cvplot;
# The cvplot rule creates a coverage plot as a PDF file for each sample, based on a CSV file, using an R script.

# Input files: ../{sample}.csv
# Output files: ../{sample}.pdf

rule cvplot:
    input:
        csv="results/{project_name}/cvplot/{sample}.csv"
    output:
        plot="results/{project_name}/cvplot/{sample}.pdf"
    conda:
        "../envs/cvplot.yaml"
    log:
        "results/{project_name}/logfiles/cvplot/{sample}.log"
    shell:
        """
        Rscript workflow/scripts/coverageplot.R {input.csv} {output.plot} {wildcards.sample} 2>> {log}
        """