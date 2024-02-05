import os
from ruamel.yaml import YAML

def list_files_to_textfile(config_path, file_extensions, main_dir):
    # Initialize YAML parser
    yaml = YAML()

    # Read configuration file
    with open(config_path, 'r') as file:
        config = yaml.load(file)

    # Read (base_path) and the name of the (project_name) from the configuration file
    base_path = config.get('sample_path', '')
    output_file_name = config.get('project_name', '')
    if not base_path or not output_file_name:
        raise ValueError("base_path oder output_file_name ist nicht in der Konfigurationsdatei definiert.")

    # Create the (results) folder and the specific subfolder with your project name
    results_dir = os.path.join(main_dir, "../results")
    specific_dir = os.path.join(results_dir, output_file_name)
    os.makedirs(specific_dir, exist_ok=True)

    # Create the complete path of the output file, including the .txt file extension
    output_textfile_path = os.path.join(specific_dir, output_file_name + ".txt")

    # Create a list of all samples
    input_files = [f for f in os.listdir(base_path) if any(f.endswith(ext) for ext in file_extensions)]

    # Save the list in a text file
    with open(output_textfile_path, 'w') as file:
        for filename in input_files:
            file.write("%s\n" % filename)

if __name__ == "__main__":
    # Determine the root directory of the Snakemake project
    main_dir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))

    config_path = os.path.join(main_dir, "../config/config.yaml")  # Path of the configuration file
    file_extensions = [".fastq.gz"]  # Customize list of file extensions here

    list_files_to_textfile(config_path, file_extensions, main_dir)