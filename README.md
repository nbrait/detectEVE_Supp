# detectEVE: fast, sensitive and precise detection of endogenous viral elements in genomic data

**Nadja Brait, Thomas Hackl, Sebastian Lequime**

### Purpose 
Repository containing supplementary material such as raw output of tools, sequences, and additional scripts. The tool itsel can be found at https://github.com/thackl/detectEVE

### Abstract
**Summary** Endogenous viral elements (EVEs) are fragments of viral genomic material embedded within the host genome. Retroviruses contribute to the majority of EVEs due to their genomic integration during their life cycle, however, the latter can also arise from non-retroviral RNA or DNA viruses, then collectively known as non-retroviral (nr)EVEs. Detecting nrEVEs poses challenges due to their sequence and genomic structural diversity, contributing to the scarcity of specific tools designed for nrEVEs detection.

Here, we introduce detectEVE, a user-friendly and open-source tool designed for the accurate identification of nrEVEs in genomic assemblies. detectEVE deviates from other nrEVE detection pipelines, which usually classify sequences in a more rigid manner as either virus-associated or not. Instead, we implemented a scaling system assigning confidence scores to hits in protein sequence similarity searches, using bit score distributions and search hints related to various viral characteristics, allowing for higher sensitivity and specificity. Our benchmarking shows that detectEVE is computationally efficient and accurate, as well as considerably faster than existing approaches, due to its resource-efficient parallel execution.

Our tool can help to fill current gaps in both host-associated fields and virus-related studies. This includes (i) enhancing genome annotations with metadata for EVE loci, (ii) conducting large-scale paleo-virological studies to explore deep viral evolutionary histories, and (iii) aiding in the identification of actively expressed EVEs in transcriptomic data, reducing the risk of misinterpretations between exogenous viruses and EVEs.

**Availability and Implementation** detectEVE is implemented as snakemake workflow, available with detailed documentation at https://github.com/thackl/detectEVE and can be easily installed using conda.

### Citation
BioRxiv. https://doi.org/10.1101/2023.09.08.556789

### Project Workflow
![Alt text](/Workflow_figure_github.png?raw=true "Project workflow")


