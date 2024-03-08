def get_full_sample_path(sample, technology="ONT"):
    sample_files = samples[sample].get(technology, [])
    if sample_files:
        # Gehe davon aus, dass die Dateien im entsprechenden Unterordner liegen
        return [os.path.join(config["sample_path"], sample, "ont", file_name) for file_name in sample_files]
    else:
        raise ValueError(f"Keine Dateien für die Probe {sample} und Technologie {technology} gefunden.")



# rule bioawk; create a read-length table
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