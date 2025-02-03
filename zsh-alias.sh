#!/bin/bash

# Ruta por defecto al archivo .zshrc
ZSHRC="$HOME/.zshrc"

# Verificar si se usa el modo test
if [[ "$1" == "--test" ]]; then
  ZSHRC="$HOME/.zshrc.test"
  echo "🧪 Modo TEST activado: Se usará $ZSHRC en lugar de ~/.zshrc"
  >"$ZSHRC" # Limpia el archivo para pruebas
fi

# Mensajes con iconos
ADDED="✨"
EXISTS="✅"
ERROR="❌"
APPLIED="🚀"

# Definir equivalencias de nombres en español e inglés
declare -A DIR_NAMES=(
  ["Desktop"]="Escritorio"
  ["Downloads"]="Descargas"
  ["Documents"]="Documentos"
  ["Pictures"]="Imágenes"
  ["Videos"]="Videos"
)

# Función para verificar si una línea ya existe en el archivo ZSHRC
exists_in_zshrc() {
  grep -qF "$1" "$ZSHRC"
}

# Función para agregar encabezado si no existe
add_section_header() {
  local header="$1"
  exists_in_zshrc "$header" || echo -e "\n$header\n" >>"$ZSHRC"
}

# Función para obtener el directorio correcto (verifica inglés primero, luego español)
get_dir_path() {
  local eng="$HOME/$1"
  local esp="$HOME/${DIR_NAMES[$1]}"
  [[ -d "$eng" ]] && echo "$eng" && return
  [[ -d "$esp" ]] && echo "$esp" && return
  echo "$eng" # Si ninguna existe, usar la versión en inglés por defecto
}

# Agregar alias generales
add_section_header "# --- Alias del sistema ---"
declare -A ALIASES=(
  ["ll"]="ls -l"
  ["la"]="ls -la"
)

if command -v lsds >/dev/null 2>&1; then
  ALIASES['ls']="lsd"
fi

for alias_name in "${!ALIASES[@]}"; do
  alias_command="${ALIASES[$alias_name]}"
  exists_in_zshrc "alias $alias_name=" && echo -e "$EXISTS Alias '$alias_name' ya existe." && continue
  echo "alias $alias_name='$alias_command'" >>"$ZSHRC"
  echo -e "$ADDED Alias '$alias_name' agregado."
done

# Agregar alias de Git
add_section_header "# --- Alias de Git ---"
declare -A GIT_ALIASES=(
  ["gpl"]="git pull"
  ["gps"]="git push"
  ["gsw"]="git switch"
  ["gbr"]="git branch"
  ["gts"]="git status"
  ["glg"]="git log --oneline --decorate --graph"
  ["gcm"]="git commit"
)
for alias_name in "${!GIT_ALIASES[@]}"; do
  alias_command="${GIT_ALIASES[$alias_name]}"
  exists_in_zshrc "alias $alias_name=" && echo -e "$EXISTS Alias '$alias_name' ya existe." && continue
  echo "alias $alias_name='$alias_command'" >>"$ZSHRC"
  echo -e "$ADDED Alias '$alias_name' agregado."
done

# Agregar alias para cambiar directorios
add_section_header "# --- Alias de directorios ---"
declare -A CDALIASES=(
  ["cdt"]="Desktop"
  ["cdd"]="Downloads"
  ["cdo"]="Documents"
  ["cdi"]="Pictures"
  ["cdv"]="Videos"
)
for cd_alias in "${!CDALIASES[@]}"; do
  dir_path=$(get_dir_path "${CDALIASES[$cd_alias]}")
  [[ ! -d "$dir_path" ]] && echo -e "$ERROR No se encontró un directorio válido para '$cd_alias'." && continue

  func_definition="
${cd_alias}() { cd \"$dir_path/\$@\" ; }
compdef '_files -/' $cd_alias
"
  exists_in_zshrc "$cd_alias() {" && echo -e "$EXISTS La función '$cd_alias' ya existe." && continue
  echo "$func_definition" >>"$ZSHRC"
  echo -e "$ADDED Función '$cd_alias' agregada."
done

# Recargar configuración solo si no está en modo test
[[ "$1" != "--test" ]] && source "$ZSHRC" && echo -e "$APPLIED Configuración aplicada."
[[ "$1" == "--test" ]] && echo "🧪 Test completado. Revisa $ZSHRC para verificar los cambios."
