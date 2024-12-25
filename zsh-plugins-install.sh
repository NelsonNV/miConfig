#!/bin/bash

# Ruta donde se instalarán los plugins
PLUGIN_DIR="$HOME/.zshp"

# Plugins a instalar (repositorios de GitHub y archivos .zsh correspondientes)
declare -A PLUGINS=(
  ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
  ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
  ["fzf-tab"]="https://github.com/Aloxaf/fzf-tab.git"
)

# Iconos
ICON_SUCCESS="✅"
ICON_ADDED="✨"
ICON_ERROR="❌"
ICON_APPLIED="🚀"

# Crear el directorio para los plugins si no existe
if [ ! -d "$PLUGIN_DIR" ]; then
  mkdir -p "$PLUGIN_DIR"
  echo "$ICON_ADDED Directorio para plugins creado en $PLUGIN_DIR."
else
  echo "$ICON_SUCCESS El directorio para plugins ya existe en $PLUGIN_DIR."
fi

# Ruta al archivo .zshrc
ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"

# Línea que deseas agregar
COMPINIT_LINE="autoload -U compinit && compinit"

# Comprobar si la línea ya existe
if grep -Fxq "$COMPINIT_LINE" "$ZSHRC"; then
  echo "✅ La línea '$COMPINIT_LINE' ya está presente en $ZSHRC."
else
  echo "$COMPINIT_LINE" >>"$ZSHRC"
  echo "✨ La línea '$COMPINIT_LINE' se ha añadido a $ZSHRC."
fi

# Instalar plugins y agregar el source al .zshrc
for plugin_repo in "${!PLUGINS[@]}"; do
  plugin_url="${PLUGINS[$plugin_repo]}"
  plugin_path="$PLUGIN_DIR/$plugin_repo"

  # Comprobar si el plugin ya está instalado
  if [ -d "$plugin_path" ]; then
    echo "$ICON_SUCCESS Plugin '$plugin_repo' ya está instalado en $plugin_path."
  else
    git clone "$plugin_url" "$plugin_path"
    if [ $? -eq 0 ]; then
      echo "$ICON_ADDED Plugin '$plugin_repo' instalado correctamente en $plugin_path."
    else
      echo "$ICON_ERROR Error al instalar el plugin '$plugin_repo'."
      continue
    fi
  fi

  # Comprobar si el source ya está en .zshrc
  plugin_file="$plugin_path/$plugin_repo.zsh"
  if grep -q "source $plugin_file" "$ZSHRC"; then
    echo "$ICON_SUCCESS Configuración del plugin '$plugin_repo' ya existe en $ZSHRC."
  else
    echo "source $plugin_file" >>"$ZSHRC"
    echo "$ICON_ADDED Configuración del plugin '$plugin_repo' añadida a $ZSHRC."
  fi
done

# Recargar el archivo .zshrc
source "$ZSHRC"
echo "$ICON_APPLIED Configuración de plugins aplicada."
