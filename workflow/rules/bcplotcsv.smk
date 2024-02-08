# rule bcplotcsv; create a csv file for BUSCO plot
rule bcplotcsv:
    input:
        busco_sum="results/{project_name}/busco/{sample}_short_summary.txt"
    output:
        csvfile="results/{project_name}/csvbusco/{sample}_busco.csv"
    conda:
        "../envs/bcplotcsv.yaml"
    params:
        prefix=lambda wildcards: wildcards.sample,
        temp_dir="results/{project_name}/csvbusco/{sample}_temp/"
    shell:
        """
        echo "Strain,Complete_single_copy,Complete_duplicated,Fragmented,Missing" > {output.csvfile}
        mkdir -p {params.temp_dir}
        cat {input.busco_sum} | grep "(S)" | awk -v strain="{params.prefix}" '{{print strain","$1}}' > {params.temp_dir}/complete_single.txt
        cat {input.busco_sum} | grep "(D)" | awk '{{print $1}}' > {params.temp_dir}/complete_duplicated.txt
        cat {input.busco_sum} | grep "(F)" | awk '{{print $1}}' > {params.temp_dir}/fragmented.txt
        cat {input.busco_sum} | grep "(M)" | awk '{{print $1}}' > {params.temp_dir}/missing.txt
        paste -d "," {params.temp_dir}/complete_single.txt {params.temp_dir}/complete_duplicated.txt {params.temp_dir}/fragmented.txt {params.temp_dir}/missing.txt >> {output.csvfile}
        rm -r {params.temp_dir}
        """