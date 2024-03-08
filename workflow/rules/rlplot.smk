# rule rlplot; create a read-length plot
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