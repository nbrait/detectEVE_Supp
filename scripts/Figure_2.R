# Script for Figure 2 - Performance comparisons
# Nadja Brait

setwd("C:/Users/nadja/Documents/LaptopAsus/PhD/detectEVE_PC")

###################
#install.packages("lubridate")
library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(gridExtra)
#library(lubridate)
library(tidyverse)
###################

# input

#data <- read_tsv("Tool_comparison_metrics.tsv", col_names = TRUE)
data <- read_tsv("Tool_comparison_metrics_new.tsv", col_names = TRUE, col_types = cols(
  Tool = col_character(),  
  Runningtime = col_character(), 
  .default = col_double() 
))

# convert time to appropriate format (seconds) 
convert_to_seconds <- function(time_str) {
  if (is.na(time_str)) {
    return(NA)
  }
  
# Check for h:m:s or m:s format with dots as separators
  parts <- as.numeric(str_split(time_str, "\\:", simplify = TRUE))
  if (length(parts) == 3) {
    return(parts[1] * 3600 + parts[2] * 60 + parts[3])
  } else if (length(parts) == 2) {
    return(parts[1] * 60 + parts[2])
  }
  
  return(NA)  
}

# time conversion
data <- data %>%
  mutate(
    Runningtime = sapply(Runningtime, convert_to_seconds),
    Tool = as.factor(Tool)  # Ensure Tool column is factor for plotting
  )
# determine means and standard deviations
summary_data <- data %>%
  group_by(Tool, Threads) %>%
  summarise(
    Runningtime_mean = mean(Runningtime, na.rm = TRUE),
    CPUPercent_mean = mean(CPUPercent, na.rm = TRUE),
    MemoryUsage_mean = mean(MemoryUsage, na.rm = TRUE),
    Runningtime_sd = sd(Runningtime, na.rm = TRUE),
    CPUPercent_sd = sd(CPUPercent, na.rm = TRUE),
    MemoryUsage_sd = sd(MemoryUsage, na.rm = TRUE)
  ) %>%
  pivot_longer(
    cols = c(Runningtime_mean, CPUPercent_mean, MemoryUsage_mean, Runningtime_sd, CPUPercent_sd, MemoryUsage_sd),
    names_to = c("Metric", ".value"),
    names_pattern = "(.*)_(.*)"
  )

summary_data <- summary_data %>%
  mutate(mean = as.numeric(mean),
         sd = as.numeric(sd))

#write_tsv(summary_data, "summary_tool_comparison.tsv")

#######
# PLOT
#######

tool_colors <- c("detectEVE" = "darkred", "Palatini" = "orange", "DIGS" = "darkblue")
ggplot(summary_data, aes(x = factor(Threads), y = mean, fill = Tool)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), position = position_dodge(.9), width = 0.25) +
  facet_wrap(~ Metric, scales = "free_y", labeller = labeller(Metric = c(
    "Runningtime" = "Running Time (seconds)",
    "CPUPercent" = "CPU Usage (%)",
    "MemoryUsage" = "Memory Usage (kbytes)"
  ))) +
  theme_minimal() +
  labs(x = "Number of Threads", y = "Mean Value (log scale)") +
  scale_y_continuous(labels = scales::comma, trans = 'log10') +
  scale_fill_manual(values = tool_colors)

#######
# statistics
#######

library(rstatix)


#data$Tool <- as.factor(data$Tool)
#data$Threads <- as.factor(data$Threads)

# Kruskal-Wallis test for running time vs. Threads per tool
kruskal_results <- data %>%
  group_by(Tool) %>%
  summarise(
    kruskal_p_value = kruskal.test(Runningtime ~ Threads)$p.value
  )

print(kruskal_results)


# Spearman correlation for threads and running time
spearman_results <- data %>%
  group_by(Tool) %>%
  summarise(
    spearman_corr = cor(Threads, Runningtime, method = "spearman"),
    spearman_p_value = cor.test(Threads, Runningtime, method = "spearman")$p.value
  )

print(spearman_results)
