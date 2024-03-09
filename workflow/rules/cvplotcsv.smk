# rule cvplotcsv;
# The cvplotcsv rule generates a CSV file for 
# coverage plots by extracting length information from Fasta files 
# and recording this data together with predefined parameters 
# such as stem and data type for each sequence.

# Input files: fasta=get_cvplotcsv_input; .fasta files!
# Output files: ../{sample}.csv

# The get_cvplotcsv_input function selects the input fasta file for creating the coverage plot, based on whether Illumina data is available, from either piloted or racon-polished sequences.
def get_cvplotcsv_input(wildcards):
    if config["illumina_data"]:
        return "results/{project_name}/pilon/{sample}_pilon.fasta"
    else:
        return "results/{project_name}/racon/{sample}.fasta"


rule cvplotcsv:
    input:
        fasta=get_cvplotcsv_input
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