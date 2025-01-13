setwd("C:/Users/nadja/Documents/LaptopAsus/PhD/detectEVE_PC")

#install.packages("ggplot2")
library(ggplot2)

###########

# PLOT

###########

df <- read_tsv("tool_comparison.tsv", col_names = TRUE)

df$Tool <- factor(df$Tool, levels = c("Lequime et al. 2017", "detectEVE", "Palatini", "DIGS"))
df$CONTIG <- factor(df$CONTIG, levels = c("APHL01005937.1", "ATLV01019207.1", "AXCK02024744.1", "AXCL01017469.1", "AXCP01005692.1", "APCM01026709.1"))

ggplot(df, aes(x = CONTIG, y = LENGTH, fill = Tool)) +
  geom_bar(stat = "identity", position = position_dodge2(preserve = "single")) +
  labs(title = "Comparison of tools for Flavivirus EVE detection in Anopheles genomes",
       x = "scaffold",
       y = "aa length") +
  theme_light() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
  scale_fill_manual(values = c("Lequime et al. 2017" = "grey", "DIGS" = "darkblue", "Palatini" = "orange", "detectEVE" = "darkred")) +
  scale_y_continuous(breaks = c(100, 1000, max(df$LENGTH)), labels = c(100, 1000, max(df$LENGTH)))


##########################

##########

df <- df %>%
  complete(Tool, CONTIG, fill = list(START = NA, END = NA, LENGTH = NA))

ggplot(df, aes(x = Tool, ymin = START, ymax = END, fill = Tool, colour = Tool)) +
  # Use errorbars instead of linerange
  geom_errorbar(size = 1.5, width = 0.2) +
  
  geom_text(
    aes(y = START - 20, label = paste(START)),  # Place START below the line
    vjust = 1,  # Below the error bar
    size = 3,
    show.legend = FALSE
  ) +
  
  geom_text(
    aes(y = END + 20, label = paste(END)),  # Place END above the line
    vjust = 0,  # Above the error bar
    size = 3,
    show.legend = FALSE
  ) +
  
  geom_text(
    aes(y = (START + END) / 2, label = paste(LENGTH, "nt")), hjust = 0.5,  
    angle = 90, size = 3, show.legend = FALSE) +
  
  labs(x = "Tool", y = "Position on Contig", fill = "Tool") +
  
  facet_wrap(~CONTIG, scales = "free", ncol = 3) + 
  
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "top") +
  
  scale_color_manual(
    values = c("Lequime et al. 2017" = "grey", "DIGS" = "darkblue", "Palatini" = "orange", "detectEVE" = "darkred"),
    name = "Tool:", guide = guide_legend(reverse = TRUE))


###########

#STATISTICS

###########

# see if there is significance in differences of lengths of tools
# Kruskal–Wallis test
kruskal.test(LENGTH ~ Tool, data = df)
