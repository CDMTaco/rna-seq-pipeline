#!/bin/bash
# ===============================================
# 🧬 RNA-seq Pipeline - Análisis transcriptómico
# Autor: Álvaro Gómez (TACO)
# -----------------------------------------------
# Este pipeline automatiza un análisis completo de RNA-seq,
# incluyendo control de calidad, trimming, alineamiento,
# cuantificación por genes y validación básica de conteos.
# ===============================================

# ESTRUCTURA DEL REPOSITORIO:
# rna-seq-pipeline/
# ├── RNA-seqAGomez.R               # Script maestro en R
# ├── bin/                          # Scripts intermedios
# │   ├── check_dependencies.sh     # Verifica herramientas necesarias
# │   ├── preproc.sh                # QC y trimming
# │   ├── indexado.sh               # Indexado del genoma
# │   ├── alineamiento.sh           # Mapeo con STAR
# │   └── featurecount.sh           # Cuantificación con featureCounts
# ├── data/                         # (opcional) carpeta sugerida para datos crudos
# ├── counts/                       # Salidas de cuantificación
# └── README.sh                     # Este archivo

# -----------------------------------------------
# 📦 REQUISITOS
# -----------------------------------------------
# Herramientas requeridas:
#   - fastqc
#   - trim_galore
#   - STAR
#   - featureCounts (Subread)
#   - prefetch y fasterq-dump (SRA Toolkit)
#   - R + paquete "glue"
#
# Instalar "glue" desde R:
# Rscript -e 'install.packages("glue")'

# -----------------------------------------------
# ▶️ USO
# -----------------------------------------------
# 1. Edita las rutas en el script RNA-seqAGomez.R:
#    - Directorio con archivos fastq.gz
#    - Genoma FASTA y anotación GTF
#
# 2. Ejecuta el pipeline completo:
#    Rscript RNA-seqAGomez.R
#
# 3. El script generará y correrá los pasos:
#    🔹 Verificación de herramientas
#    🔹 FastQC + Trimming
#    🔹 Indexado del genoma
#    🔹 Alineamiento con STAR
#    🔹 Cuantificación con featureCounts
#    🔹 Validación básica del archivo de conteos

# -----------------------------------------------
# 📁 SALIDAS GENERADAS
# -----------------------------------------------
# - QC/: Reportes FastQC por muestra
# - trimmed/: Lecturas limpias (.fq.gz)
# - index_STAR/: Índices generados por STAR
# - alignments/: Archivos BAM alineados
# - counts/counts.txt: Matriz de conteo por genes

# -----------------------------------------------
# 🔬 DETALLES TÉCNICOS
# -----------------------------------------------
# - El pipeline está optimizado para lecturas single-end (SE)
# - Usa por defecto 8 hilos, configurable por variable
# - Compatible con SRA Toolkit para descarga y conversión de datos

# -----------------------------------------------
# 👨‍🔬 AUTOR
# -----------------------------------------------
# Álvaro Gómez (TACO)
# Bioingeniería · Universidad de Concepción
# Tesis en Bioinformática y Transcriptómica
# GitHub: https://github.com/CDMTaco
