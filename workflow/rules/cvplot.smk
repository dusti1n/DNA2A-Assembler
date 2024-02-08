# rule cvplot; create a coverage plot
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
        Rscript workflow/scripts/plot_coverage.R {input.csv} {output.plot} {wildcards.sample} 2>> {log}
        """