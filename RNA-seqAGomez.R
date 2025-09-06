# ===============================
# 📌 PARÁMETROS GENERALES 
# ===============================
datos_crudos <- "/ruta/a/datos_crudos"
datos_limpios <- "trimmed"
genoma_fasta <- "/ruta/al/genoma/genome.fa"
annotation_gtf <- "/ruta/a/anotacion/annotation.gtf"
n_threads <- 8
index_dir <- file.path(dirname(genoma_fasta), "index_STAR")

# ===============================
# 🔧 0. VERIFICACIÓN DE DEPENDENCIAS
# ===============================
system("bash bin/check_dependencies.sh")

# ===============================
# 🧪 1. PREPROCESAMIENTO (QC + Trimming)
# ===============================
library(glue)

preproc_script <- glue('
mkdir -p QC {datos_limpios}
fastqc {datos_crudos}/*.fastq.gz -o QC

for sample in {datos_crudos}/*.fastq.gz
do
    trim_galore --quality 20 --phred33 --length 36 --output_dir {datos_limpios} "$sample"
done
')
writeLines(preproc_script, "bin/preproc.sh")
Sys.chmod("bin/preproc.sh", "755")
system("bash bin/preproc.sh")

# ===============================
# 🧬 2. INDEXADO STAR
# ===============================
index_script <- glue('
mkdir -p {index_dir}

STAR --runThreadN {n_threads} \
--runMode genomeGenerate \
--genomeDir {index_dir} \
--genomeFastaFiles {genoma_fasta} \
--sjdbGTFfile {annotation_gtf} \
--sjdbOverhang 100
')
writeLines(index_script, "bin/indexado.sh")
Sys.chmod("bin/indexado.sh", "755")
system("bash bin/indexado.sh")

# ===============================
# 🧬 3. ALINEAMIENTO
# ===============================
alineamiento_script <- glue('
mkdir -p alignments

for sample in {datos_limpios}/*.fq.gz
do
    base=$(basename "$sample" .fq.gz)
    STAR --genomeDir {index_dir} \
         --readFilesIn "$sample" \
         --runThreadN {n_threads} \
         --outSAMtype BAM SortedByCoordinate \
         --outFileNamePrefix alignments/"$base"_
done
')
writeLines(alineamiento_script, "bin/alineamiento.sh")
Sys.chmod("bin/alineamiento.sh", "755")
system("bash bin/alineamiento.sh")

# ===============================
# 📊 4. FEATURECOUNTS
# ===============================
featurecount_script <- glue('
mkdir -p counts
featureCounts -T {n_threads} \
-a {annotation_gtf} \
-o counts/counts.txt alignments/*_Aligned.sortedByCoord.out.bam
')
writeLines(featurecount_script, "bin/featurecount.sh")
Sys.chmod("bin/featurecount.sh", "755")
system("bash bin/featurecount.sh")

# ===============================
# 🔎 5. VALIDACIÓN SIMPLE EN R
# ===============================
conteos <- read.delim("counts/counts.txt", comment.char = "#", check.names = FALSE)
cat("✅ Lectura del archivo counts completada. Dimensiones:\n")
print(dim(conteos))