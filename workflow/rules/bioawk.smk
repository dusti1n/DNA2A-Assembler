# rule bioawk;
# The bioawk rule creates a table of read lengths by 
# running through .fastq files and writing the length 
# of the sequences together with the sample name to a CSV file for each sample.

# Input files: fastq=lambda wildcards: get_full_sample_path(wildcards.sample); fastq.gz files!
# Output files: ../{sample}.csv

# The function searches a dictionary for files for a given sample and technology and generates paths to these files;
def get_full_sample_path(sample, technology="ONT"):
    sample_files = samples[sample].get(technology, [])
    if sample_files:
        return [os.path.join(config["sample_path"], sample, "ont", file_name) for file_name in sample_files]
    else:
        raise ValueError(f"Keine Dateien für die Probe {sample} und Technologie {technology} gefunden.")


rule bioawk:
    input:
        fastq=lambda wildcards: get_full_sample_path(wildcards.sample)
    output:
        csv="results/{project_name}/csvfile/{sample}.csv"
    conda:
        "../envs/bioawk.yaml"
    log:
        "results/{project_name}/logfiles/bioawk/{sample}.log"
    shell:
        """
        echo 'sample,length' > {output.csv} 2>> {log}
        bioawk -c fastx '{{print "{wildcards.sample}," length($seq)}}' {input.fastq} >> {output.csv} 2>> {log}
        """