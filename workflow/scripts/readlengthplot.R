# FIXED ERRORS IN RSCRIPT; LINK TO PAPER: (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9254108/):
# 1-Some Libarys were missing; Add library(plyr) before library(dplyr); Add library(scales);
# 2-Change variable name: 20 kb.length.plot => length_plot_20kb
# 3-Use "linewidth" instead of "size" => Line:30,39: size=0.2 => linewidth=0.2;
# 4-Add important libarys in environment.yml for conda; r-base; r-ggplot2; r-plyr; r-dplyr; r-cowplot; r-scales;

#!/usr/bin/env Rscript
# Load the required packages
library(ggplot2)
library(plyr)
library(dplyr)
library(cowplot)
library(scales)

args <- commandArgs(trailingOnly = TRUE)
input_csv <- args[1]
output_plot <- args[2]
wildcard_sample <- args[3]  # Value of the wildcard name

# Import the read-length distribution table
read_length_df <- read.csv(input_csv)

# Organize the imported read-length table
read_length_df$sample <- as.factor(read_length_df$sample)
read_length_df$sample <- factor(read_length_df$sample,level = c(wildcard_sample))

# Calculate the average read-lengths for each sample
summary_df <- ddply(read_length_df, "sample", summarise, grp.mean=mean(length))

# Draw a read-length distribution plot for all reads
total.length.plot <- ggplot(read_length_df, aes(x=length, fill=sample, color=sample)) +
 geom_histogram(binwidth=100, alpha=0.5, position="dodge") +
 geom_vline(data=summary_df, aes(xintercept=grp.mean, color=sample), linetype="dashed", linewidth=0.2) +
 scale_x_continuous(labels = comma) +
 scale_y_continuous(labels = comma) +
 labs(x = "Read length (bp)", y = "Count") +
 theme_bw()

# Draw a read-length distribution plot for reads ≤ 20 kb in length
length_plot_20kb <- ggplot(read_length_df, aes(x=length, fill=sample, color=sample)) +
 geom_histogram(binwidth=50, alpha=0.5, position="dodge") +
 geom_vline(data=summary_df, aes(xintercept=grp.mean, color=sample), linetype="dashed", linewidth=0.2) +
 scale_x_continuous(labels = comma, limit = c(0,20000)) +
 scale_y_continuous(labels = comma) +
 labs(x = "Read length (bp)", y = "Count") +
 theme_bw()

# Merge both the read-length distribution plots
plot <- plot_grid(total.length.plot, length_plot_20kb, ncol = 1)

# Save the figure using the file name, “read.length.pdf”
pdf(output_plot ,width=6,height=8,paper='special')

print(plot)
dev.off()