#!/bin/bash

# Configuración de Git
echo "Configurando git  ..."

# Configurar nombre de usuario
read -p "Ingresa tu nombre de usuario de Git: " git_username
git config --global user.name "$git_username"

# Configurar correo electrónico
read -p "Ingresa tu correo electrónico de Git: " git_email
git config --global user.email "$git_email"

# Agregar alias de Git
echo "Agregando alias..."

git config --global alias.graph "log --graph --color --oneline --decorate --all"
git config --global alias.lg "log --graph --color --oneline --decorate --all"
git config --global alias.sw "switch"
git config --global alias.st "status"
git config --global alias.rank "shortlog -sn"
git config --global alias.br "branch"

# Configurar editor de texto (vim o nvim)
echo "Configurando el editor de texto para Git..."

if command -v nvim &>/dev/null; then
  git config --global core.editor "nvim"
  echo "nvim ha sido configurado como editor por defecto."
elif command -v vim &>/dev/null; then
  git config --global core.editor "vim"
  echo "vim ha sido configurado como editor por defecto."
else
  echo "Ni vim ni nvim están instalados. Git usará el editor predeterminado del sistema."
fi

git config --global init.defaultBranch trunk

echo "Configuración completada con éxito."
