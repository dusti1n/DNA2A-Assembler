# rule unzip;
# The unzip rule decompresses gz-compressed files from ONT sequences to FastQ files.

# Input files: gzipped=lambda wildcards: get_full_sample_path(wildcards.sample); .fastq.gz files!
# Output files: ../{sample}.fastq

# # The function searches a dictionary for files for a given sample and technology and generates paths to these files;
def get_full_sample_path(sample, technology="ONT"):
    sample_files = samples[sample].get(technology, [])
    if sample_files:
        return [os.path.join(config["sample_path"], sample, "ont", file_name) for file_name in sample_files]
    else:
        raise ValueError(f"Keine Dateien für die Probe {sample} und Technologie {technology} gefunden.")


rule unzip:
    input:
        gzipped=lambda wildcards: get_full_sample_path(wildcards.sample)
    output:
        unzipped=temp("results/{project_name}/temp/{sample}.fastq")
    conda:
        "../envs/unzip.yaml"
    log:
        "results/{project_name}/logfiles/unzip/{sample}.log"
    threads: num_cores
    shell:
        """
        pigz -d -c {input.gzipped} > {output.unzipped} 2>> {log}
        """