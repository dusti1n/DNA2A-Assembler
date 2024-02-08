# rule cvplot_csv; create a csv file for coverage plot
rule cvplotcsv:
    input:
        fasta="results/{project_name}/racon/{sample}.fasta"
    output:
        csv="results/{project_name}/cvplot/{sample}.csv"
    conda:
        "../envs/cvplotcsv.yaml"
    params:
        strain="ONT_Dmel",
        data_type="contig"
    shell:
        """
        echo "line,length,type,coverage" > {output.csv}
        LEN=$(bioawk -c fastx '{{sum+=length($seq)}}END{{print sum}}' {input.fasta})
        cat {input.fasta} | bioawk -c fastx -v line="{params.strain}" '{{print line","length($seq)","length($seq)}}' | sort -k3rV -t "," | awk -F "," -v len="$LEN" -v type="{params.data_type}" 'OFS=","{{ print $1,$2,type,(sum+0)/len; sum+=$3 }}' >> {output.csv}
        """