def get_full_sample_path(sample, technology="ONT"):
    sample_files = samples[sample].get(technology, [])
    if sample_files:
        # Gehe davon aus, dass die Dateien im entsprechenden Unterordner liegen
        return [os.path.join(config["sample_path"], sample, "ont", file_name) for file_name in sample_files]
    else:
        raise ValueError(f"Keine Dateien für die Probe {sample} und Technologie {technology} gefunden.")



# rule unzip; unzip the fastq.gz files
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