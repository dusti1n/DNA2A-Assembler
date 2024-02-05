#!/usr/bin/env Rscript
# Load the conflicted package to resolve conflicts
library(conflicted)

# Prefer dplyr functions in case of conflicts
conflict_prefer("filter", "dplyr")
conflict_prefer("lag", "dplyr")

# Load other necessary packages
library(ggplot2)
library(reshape2)
library(tidyverse)

args <- commandArgs(trailingOnly = TRUE)
input_csv <- args[1]
output_plot <- args[2]
wildcard_sample <- args[3]  # Value of the wildcard name

# Import the BUSCO table
busco_df <- read.csv(input_csv, header = TRUE)

# Organize and rearrange the imported table
busco_df$Strain <- as.factor(busco_df$Strain)
busco_df.melted <- melt(busco_df, id.vars = "Strain")
busco_df.melted$variable <- relevel(busco_df.melted$variable, "Missing")

# Create a stacked bar plot for the BUSCO outputs
busco_plot <- ggplot(busco_df.melted, aes(x = Strain, fill = fct_rev(variable), y = value)) +
  geom_bar(position = "stack", width = 0.7, stat = "identity") +
  labs(x = "Strain", y = "BUSCO", fill = "Type") +
  scale_y_continuous(labels = scales::comma) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
        axis.text.y = element_text(size = 12),
        axis.title = element_text(size = 12))

# Save the plot as "busco.pdf"
pdf(output_plot, width = 8, height = 5, paper = 'special')
print(busco_plot)
dev.off()