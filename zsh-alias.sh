#!/bin/bash

# Configuración de alias de comandos 'ls'
declare -A ALIASES=(
  ["ls"]="lsd"
  ["ll"]="ls -l"
  ["la"]="ls -la"
)

# Configuración de alias para cambiar directorios
declare -A CDALIASES=(
  ["cdt"]="Escritorio Desktop"
  ["cdd"]="Descargas Downloads"
  ["cdo"]="Documentos Documents"
  ["cdi"]="Imágenes Pictures"
  ["cdv"]="Videos Videos"
)

# Ruta al archivo .zshrc
ZSHRC="$HOME/.zshrc"

# Mensajes con íconos
ADDED="✨"
EXISTS="✅"
ERROR="❌"
APPLIED="🚀"

# Agregar alias de comandos normales
for alias_name in "${!ALIASES[@]}"; do
  alias_command="${ALIASES[$alias_name]}"
  if grep -q "alias $alias_name=" "$ZSHRC"; then
    echo -e "$EXISTS El alias '$alias_name' ya existe en $ZSHRC."
  else
    echo "alias $alias_name='$alias_command'" >>"$ZSHRC"
    echo -e "$ADDED Alias '$alias_name' agregado a $ZSHRC."
  fi
done

# Agregar alias para cambiar directorios
for cd_alias in "${!CDALIASES[@]}"; do
  IFS=' ' read -r -a dirs <<<"${CDALIASES[$cd_alias]}"
  dir_path=""
  for dir in "${dirs[@]}"; do
    if [ -d "$HOME/$dir" ]; then
      dir_path="$HOME/$dir"
      break
    fi
  done

  if [ -n "$dir_path" ]; then
    if grep -q "alias $cd_alias=" "$ZSHRC"; then
      echo -e "$EXISTS El alias '$cd_alias' ya existe en $ZSHRC."
    else
      echo "alias $cd_alias='cd $dir_path'" >>"$ZSHRC"
      echo -e "$ADDED Alias '$cd_alias' agregado a $ZSHRC."
    fi
  else
    echo -e "$ERROR No se pudo encontrar el directorio para '$cd_alias'."
  fi
done

# Recargar el archivo .zshrc
source "$ZSHRC"
echo -e "$APPLIED Configuración aplicada."
