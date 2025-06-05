# `genseqn`: Long-Read Assembly Pipeline

**genseqn** (from genome and sequence) is a comprehensive and modular Snakemake-based pipeline for the automated analysis of long-read sequencing data. It supports raw data from Oxford Nanopore Technologies (ONT) and also enables hybrid assembly workflows combining ONT and Illumina reads. This workflow is based on the protocol by Jun Kim and Chuna Kim (2022), “A beginner’s guide to assembling a draft genome and analyzing structural variants with long-read sequencing technologies”. 

## Usage of genseqn
> Please cite the repository URL and DOI if used in a publication.

Detailed usage instructions can be found here: [Install Workflow](documentation/install_workflow.pdf)

## Table of contents
1. [Dependencies](#dependencies)  
2. [DAG Plot Example](#dag-plot-example)  
3. [Install Miniconda and Mamba](#install-miniconda-and-mamba)  
4. [Create Environment and Install Workflow](#create-environment-and-install-workflow)  
6. [Folder and Data Structure](#folder-and-data-structure)  
7. [Load Samples and Start the Workflow](#load-samples-and-start-the-workflow)
10. [Run with Docker](#run-with-docker)  
11. [Optional Commands](#optional-commands)  
12. [References](#references)

## Dependencies

> **Recommended system:** [Linux (Ubuntu)](https://ubuntu.com/)

- [Snakemake](https://snakemake.readthedocs.io/en/stable/)  
  Workflow management system used to define and execute the analysis pipeline.

- [Conda](https://conda.io/en/latest/index.html)  
  Package and environment manager used to install all required software in isolated environments.

- [Python](https://www.python.org/)  
  Required as the base language for Snakemake and many bioinformatics tools.

- [R (Rscript)](https://www.r-project.org/)  
  Used for optional downstream analysis or visualization steps in the workflow.

## DAG Plot Example 

<img src="documentation/images/DAG-Plot.png" alt="DAG Plot" width="700"/>

**Fig. 1**: The Directed Acyclic Graph (DAG) illustrates the structure of the workflow.  
Black rectangles indicate rules that are activated when Illumina data is included.

## Install Miniconda and Mamba

> This workflow was tested on a [Linux (Ubuntu)](https://ubuntu.com/) system.

### 1. Install Miniconda3  

Download and install Miniconda:

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh
```

> If you do not have Mamba installed in your conda environment. 

Install Mamba (optional but recommended)

```bash
conda install -c conda-forge mamba
```

## Create environment and install workflow
**1. Create a working directory for your project:**

```bash
mkdir -p path/to/project-workdir
cd path/to/project-workdir
```
You can name the folder freely (e.g. genseqn_project) and place it wherever you prefer.

This will be your main working directory for running the genseqn pipeline.

**1. Download the Snakemake workflow from GitHub**

If you don’t have the workflow yet, you can download it from GitHub.  
Otherwise, if you already have the data locally, you can skip this step.

Clone the repository into your project directory:
> Alternatively, you can download the ZIP file from GitHub and unzip it manually.

Clone repo from GitHub
```bash
git clone https://github.com/dusti1n/DNA2A-seq-analyzer.git
```

**2. Create the conda environment**

Navigate to the folder containing `environment.yaml`, `config/`, and `workflow/`.

Create the environment and install all required packages using Conda:

```bash
conda env create -n snakenv -f environment.yaml
conda activate snakenv
```

Alternatively, using Mamba:

```bash
mamba env create -n snakenv -f environment.yaml
mamba activate snakenv
```

## Folder and data structure

<img src="documentation/images/folder_structure.jpg" alt="logo" width="700"/></p>

**Fig. 2**: This is an overview of what the folder and data structure should look like.

## Load samples and start the workflow

**1. Configure `config.yaml`**

Set the path to your sample directory. Each sample must follow this folder structure ([Fig 2.](#folder-and-data-structure)):

```
example_data/
├── smpl_01/
│   ├── ont/ontfile.fastq.gz
│   └── illumina/
│       ├── illuminafile_1.fastq
│       └── illuminafile_2.fastq
```

Update the following fields in `config.yaml`:

```yaml
sample_path: /path/to/example_data/
project_name: saccharomycetes_smpls
save_dict: true
canu_genome_size: "12m"
busco_lineage: "saccharomycetes_odb10"
fastqc_memory: "8192"
```

**2. Illumina Data (Optional)**

If you also use Illumina data, set:

```yaml
illumina_data: true
pilon_memory: "32G"
```

Set `illumina_data: false` if you're only using ONT data.

**3. Load Samples and Run Workflow**

Load samples via Python script:

```bash
python workflow/scripts/import_samples.py
```

Run the full workflow using all available cores:

```bash
snakemake --cores all --use-conda
```

The results will be saved in a subfolder named after your `project_name`.

## Run with Docker

### Preparation

1. Create a folder for your project (e.g. `<your_main_folder>`)
2. Inside this folder, create two subfolders:
   - `<your_main_folder>/config/`
   - `<your_main_folder>/results/`
3. Download the default `config.yaml` file into the `config/` folder:

```bash
wget https://raw.githubusercontent.com/dusti1n/DNA2A-seq-analyzer/master/config/config.yaml -P config/
```

4. Move your sample folder (e.g. `example_data/`) into `<your_main_folder>/`
5. Edit `config/config.yaml` accordingly.  
   **Important:** When using Docker, set:

```yaml
sample_path: /app/<your_sample_folder>
```

### Pull and Start Docker Image

1. Navigate to your `<your_main_folder>` directory
2. Pull the Docker image:

```bash
docker pull dusti1n/dna2a-seq-analyzer
```

3. Start the container:

```bash
docker run -it --name dna2a-seq-analyzer \
  -v /host/path/to/<your_main_folder>/results:/app/results \
  -v /host/path/to/<your_main_folder>/<your_sample_folder>:/app/<your_sample_folder> \
  -v /host/path/to/<your_main_folder>/config:/app/config \
  dusti1n/dna2a-seq-analyzer:latest
```

**Explanation:**

- `--name` gives the container a custom name
- `-v` binds local folders into the container
- `-it` keeps STDIN open and allocates a pseudo-TTY  
- `"host"` refers to the absolute path on your local system

Make sure the full paths are entered correctly!

### Start Workflow in Docker

1. Activate the Conda environment:

```bash
conda activate snakenv
```

2. Load your samples and start the workflow:  
   - [Load Samples with Python](#load-samples-and-start-the-workflow)

## Optional Commands

**Create a DAG plot (flowchart of the workflow):**

```bash
snakemake --dag | dot -Tpng > dag.png
```

## References

- [Jun Kim & Chuna Kim – Assembling a draft genome and analyzing structural variants with long-read sequencing](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9254108/)
- [Snakemake Documentation](https://snakemake.readthedocs.io/en/stable/)
- [Snakemake GitHub Repository](https://github.com/snakemake/snakemake)

