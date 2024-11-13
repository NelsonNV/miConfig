#!/bin/bash

# Definir la URL de la página de descargas de Nerdfonts
URL="https://www.nerdfonts.com/font-downloads"

# Directorio de instalación
FONT_DIR="$HOME/.fonts"

# Colores
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Sin color

# Iconos para la terminal (puedes usar cualquier otro símbolo o emoji)
DOWNLOAD_ICON="📥"
UNZIP_ICON="📦"
DELETE_ICON="🗑️"
CHECK_ICON="✅"
INFO_ICON="ℹ️"
ERROR_ICON="❌"

# Crear el directorio de fuentes si no existe
mkdir -p "$FONT_DIR"

# Obtener el contenido HTML de la página de descarga
echo -e "${CYAN}$INFO_ICON Descargando la lista de fuentes de Nerdfonts...${NC}"
html_content=$(curl -s "$URL")

# Extraer los enlaces .zip de la página
zip_urls=$(echo "$html_content" | grep -oP 'href="([^"]+\.zip)"' | cut -d'"' -f2)

# Contar cuántas fuentes vamos a descargar
total_fonts=$(echo "$zip_urls" | wc -w)
echo -e "${YELLOW}🔢 Se van a descargar $total_fonts fuentes NerdFonts.${NC}"

# Descargar y descomprimir cada archivo .zip
echo -e "${CYAN}$INFO_ICON Iniciando descarga y descompresión de fuentes...${NC}"

font_counter=0
for url in $zip_urls; do
    # Obtener el nombre del archivo .zip
    zip_file=$(basename "$url")
    
    # Descargar el archivo .zip
    echo -e "${GREEN}$DOWNLOAD_ICON Descargando $zip_file...${NC}"
    wget -q "$url" -O "$zip_file"

    # Descomprimir el archivo directamente en ~/.fonts (sobrescribiendo lo que sea necesario)
    echo -e "${CYAN}$UNZIP_ICON Descomprimiendo $zip_file...${NC}"
    unzip -o -q "$zip_file" -d "$FONT_DIR"

    # Eliminar el archivo zip después de descomprimir
    rm "$zip_file"
    echo -e "${RED}$DELETE_ICON Archivo $zip_file eliminado.${NC}"

    # Contar las fuentes descomprimidas
    font_counter=$((font_counter + 1))
    echo -e "${YELLOW}📊 Fuentes descargadas y descomprimidas: $font_counter/$total_fonts${NC}"

done

# Recargar la caché de fuentes
echo -e "${GREEN}$CHECK_ICON Recargando la caché de fuentes...${NC}"
fc-cache -fv

echo -e "${CYAN}$CHECK_ICON Instalación de NerdFonts completada.${NC}"

