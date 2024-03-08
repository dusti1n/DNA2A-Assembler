# rule buscoplot; create a BUSCO plot
rule buscoplot:
    input:
        csv="results/{project_name}/csvbusco/{sample}_busco.csv"
    output:
        plot="results/{project_name}/bcplot/{sample}.pdf"
    conda:
        "../envs/buscoplot.yaml"
    log:
        "results/{project_name}/logfiles/buscoplot/{sample}.log"
    shell:
        """
        Rscript workflow/scripts/buscoplot.R {input.csv} {output.plot} {wildcards.sample} 2>> {log}
        """