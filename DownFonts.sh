#!/bin/bash

# Definir la URL de la página de descargas de NerdFonts
URL="https://www.nerdfonts.com/font-downloads"

# Directorio de instalación
FONT_DIR="$HOME/.fonts"

# Colores
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Sin color

# Iconos para la terminal
DOWNLOAD_ICON="📥"
UNZIP_ICON="📦"
DELETE_ICON="🗑️"
CHECK_ICON="✅"
INFO_ICON="ℹ️"
ERROR_ICON="❌"

# Crear el directorio de fuentes si no existe
mkdir -p "$FONT_DIR"

# Obtener el contenido HTML de la página de descarga
echo -e "${CYAN}$INFO_ICON Descargando la lista de fuentes de NerdFonts...${NC}"
html_content=$(curl -s "$URL")

# Extraer los enlaces .zip de la página y eliminar duplicados
zip_urls=$(echo "$html_content" | grep -oP 'href="([^"]+\.zip)"' | cut -d'"' -f2 | sort -u)

# Contar cuántas fuentes hay en total
total_fonts=$(echo "$zip_urls" | wc -w)
echo -e "${YELLOW}🔢 Total de fuentes en NerdFonts: $total_fonts.${NC}"

# Contadores
processed_fonts=0
font_counter=0
skipped_counter=0

# Descargar y descomprimir cada archivo .zip en su propia carpeta
echo -e "${CYAN}$INFO_ICON Iniciando descarga y descompresión de fuentes...${NC}"

for url in $zip_urls; do
  # Obtener el nombre de la fuente desde la URL (sin extensión)
  zip_file=$(basename "$url")
  font_name="${zip_file%.zip}"

  # Directorio específico para la fuente
  font_path="$FONT_DIR/$font_name"

  # Incrementar el contador de fuentes procesadas
  ((processed_fonts++))

  # Si la fuente ya está instalada, omitirla
  if [[ -d "$font_path" ]]; then
    echo -e "${GREEN}$CHECK_ICON $font_name ya está instalado. Omitiendo.${NC}"
    ((skipped_counter++))
    echo -e "${YELLOW}📊 Progreso: $processed_fonts / $total_fonts${NC}"
    continue
  fi

  mkdir -p "$font_path"

  # Descargar el archivo .zip
  echo -e "${GREEN}$DOWNLOAD_ICON Descargando $font_name...${NC}"
  wget -q "$url" -O "$zip_file"

  # Descomprimir en su directorio correspondiente
  echo -e "${CYAN}$UNZIP_ICON Descomprimiendo en $font_path...${NC}"
  unzip -o -q "$zip_file" -d "$font_path"

  # Eliminar el archivo zip después de descomprimir
  rm "$zip_file"
  echo -e "${RED}$DELETE_ICON Archivo $zip_file eliminado.${NC}"

  # Incrementar el contador de fuentes nuevas descargadas
  ((font_counter++))
  echo -e "${YELLOW}📊 Progreso: $processed_fonts / $total_fonts${NC}"

done

# Resumen final
echo -e "${YELLOW}📊 Fuentes ya instaladas y omitidas: $skipped_counter${NC}"
echo -e "${GREEN}✅ Fuentes nuevas instaladas: $font_counter${NC}"
echo -e "${CYAN}📊 Total de fuentes procesadas: $processed_fonts / $total_fonts${NC}"

# Recargar la caché de fuentes si hubo cambios
if [[ $font_counter -gt 0 ]]; then
  echo -e "${GREEN}$CHECK_ICON Recargando la caché de fuentes...${NC}"
  fc-cache -fv
fi

echo -e "${CYAN}$CHECK_ICON Instalación de NerdFonts completada.${NC}"
