#!/bin/bash

# Script para reconectar a una red WiFi usando wofi
# Este script escanea las redes disponibles y permite seleccionar una usando wofi

# Verificar si los comandos necesarios están instalados
if ! command -v nmcli &>/dev/null; then
  echo "Error: nmcli no está instalado. Por favor, instala NetworkManager."
  exit 1
fi

if ! command -v wofi &>/dev/null; then
  echo "Error: wofi no está instalado. Por favor, instálalo primero."
  exit 1
fi

echo "Escaneando redes WiFi disponibles..."

# Escanear redes WiFi
nmcli device wifi rescan

# Obtener la lista de redes disponibles
WIFI_LIST=$(nmcli -f SSID,SIGNAL,SECURITY device wifi list | tail -n +2)

# Usar wofi para mostrar la lista y seleccionar una red
CHOSEN_NETWORK=$(echo "$WIFI_LIST" | wofi --dmenu --prompt "Selecciona una red WiFi:" --width 600 --height 400 | awk '{print $1}')

# Verificar si se seleccionó una red
if [ -z "$CHOSEN_NETWORK" ]; then
  echo "No se seleccionó ninguna red. Saliendo."
  exit 0
fi

echo "Conectando a $CHOSEN_NETWORK..."

# Verificar si la red ya está guardada
if nmcli connection show | grep -q "$CHOSEN_NETWORK"; then
  echo "Conectando a red guardada: $CHOSEN_NETWORK"
  nmcli connection up "$CHOSEN_NETWORK"
else
  # Si la red no está guardada, preguntar por la contraseña
  PASSWORD=$(wofi --dmenu --prompt "Introduce la contraseña para $CHOSEN_NETWORK:" --password --width 400 --height 100)

  # Conectar a la nueva red
  if [ -z "$PASSWORD" ]; then
    nmcli device wifi connect "$CHOSEN_NETWORK"
  else
    nmcli device wifi connect "$CHOSEN_NETWORK" password "$PASSWORD"
  fi
fi

# Tiempo de visualización para notificaciones: 5 segundos = 5000 milisegundos
NOTIFICATION_TIMEOUT=5000

# Verificar si la conexión fue exitosa
if [ $? -eq 0 ]; then
  echo "Conectado exitosamente a $CHOSEN_NETWORK"
  notify-send -t $NOTIFICATION_TIMEOUT "WiFi" "Conectado a $CHOSEN_NETWORK"
else
  echo "Error al conectar a $CHOSEN_NETWORK"
  notify-send -t $NOTIFICATION_TIMEOUT "WiFi" "Error al conectar a $CHOSEN_NETWORK"
fi
