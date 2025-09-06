#!/bin/bash

# ===============================
# 🔧 Verificación de dependencias
# ===============================

# Colores para salida legible (si la terminal lo permite)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NC=$(tput sgr0) # Sin color

# Lista de herramientas requeridas
tools=("fastqc" "trim_galore" "STAR" "featureCounts" "prefetch" "fasterq-dump")

echo "🔍 Comprobando herramientas necesarias..."

# Estado global de errores
MISSING=0

# Revisión de cada herramienta
for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        echo -e "${GREEN}✔ $tool está instalado.${NC}"
    else
        echo -e "${RED}✘ $tool NO está instalado.${NC}"
        MISSING=1
    fi
done

# Salida final
if [ "$MISSING" -ne 0 ]; then
    echo -e "${RED}❌ ERROR: Faltan herramientas necesarias. Abortando pipeline.${NC}"
    exit 1
else
    echo -e "${GREEN}✅ Todas las herramientas están instaladas. Continuando...${NC}"
fi

