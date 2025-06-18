#!/bin/python3
import os
import subprocess
import re
from PIL import Image

MAX_WIDTH = 60
MAX_HEIGHT = 20
MIN_WIDTH = 10
MIN_HEIGHT = 5
FOLDER = os.path.expanduser("~/.nvimheader")

def calcular_tamaño_proporcional(w, h):
    escala = min(MAX_WIDTH / w, MAX_HEIGHT / h, 1)
    return int(w * escala), int(h * escala)

def obtener_tamaño_de_nombre(nombre):
    match = re.search(r"_(\d+)x(\d+)", nombre)
    if match:
        return int(match.group(1)), int(match.group(2))
    return None, None

def generar_nuevo_nombre(nombre_original, nuevo_w, nuevo_h):
    base = os.path.splitext(nombre_original)[0]
    base = base.replace("vim_", "").split("_")[0]
    return f"vim_{base}_{nuevo_w}x{nuevo_h}.jpg"

def mostrar_con_chafa(ruta, w, h):
    os.system("clear")
    print(f"🔹 Mostrando: {os.path.basename(ruta)}  Tamaño: {w}x{h}\n")
    comando = f'chafa "{ruta}" --format symbols --symbols vhalf --stretch --size {w}x{h}'
    subprocess.call(comando, shell=True)

def ajustar_valor(actual, operacion, limite_min, limite_max):
    if operacion == "max":
        return limite_max
    if operacion == "min":
        return limite_min
    try:
        return max(limite_min, min(limite_max, actual + int(operacion)))
    except ValueError:
        return actual

def modo_interactivo():
    for nombre in sorted(os.listdir(FOLDER)):
        ruta = os.path.join(FOLDER, nombre)
        if not os.path.isfile(ruta):
            continue
        if not nombre.lower().endswith((".jpg", ".jpeg", ".png", ".gif", ".webp")):
            continue

        try:
            with Image.open(ruta) as img:
                w, h = img.size
                sugerido_w, sugerido_h = calcular_tamaño_proporcional(w, h)

            actual_w, actual_h = obtener_tamaño_de_nombre(nombre)
            if actual_w == sugerido_w and actual_h == sugerido_h:
                print(f"✅ {nombre} ya tiene dimensiones correctas")
                continue

            while True:
                mostrar_con_chafa(ruta, sugerido_w, sugerido_h)

                print("📐 Original:", f"{w}x{h}")
                print("💡 Propuesta:", f"{sugerido_w}x{sugerido_h}")
                print("\nComandos rápidos:")
                print("  a / Enter   → aceptar")
                print("  s           → saltar")
                print("  w+5 / w-3   → ancho +5 / -3")
                print("  h+2 / h=max → alto +2 / al máximo")
                print("  q           → salir")

                opt = input("👉 Acción: ").strip().lower()
                if opt in ("", "a"):
                    break
                elif opt == "s":
                    sugerido_w = sugerido_h = None
                    print("⏭️  Saltado.")
                    break
                elif opt == "q":
                    print("👋 Cancelado por el usuario.")
                    return
                else:
                    match = re.match(r"([wh])([+-]?)(\d+|min|max)?", opt)
                    if match:
                        dim, signo, valor = match.groups()
                        if signo == "+" or signo == "-":
                            delta = int(valor) if valor else 1
                            delta = delta if signo == "+" else -delta
                        else:
                            delta = valor  # Puede ser "min" o "max"

                        if dim == "w":
                            sugerido_w = ajustar_valor(sugerido_w, delta, MIN_WIDTH, MAX_WIDTH)
                        elif dim == "h":
                            sugerido_h = ajustar_valor(sugerido_h, delta, MIN_HEIGHT, MAX_HEIGHT)
                        continue

                    print("❓ Comando no reconocido.")

            if sugerido_w and sugerido_h:
                nuevo_nombre = generar_nuevo_nombre(nombre, sugerido_w, sugerido_h)
                nueva_ruta = os.path.join(FOLDER, nuevo_nombre)
                os.rename(ruta, nueva_ruta)
                print(f"\n✅ Renombrado a: {nuevo_nombre}")
                input("⏎ Presiona Enter para continuar...\n")

        except Exception as e:
            print(f"❌ Error con {nombre}: {e}")

if __name__ == "__main__":
    print("🎨 Editor visual con chafa para imágenes de Neovim\n")
    modo_interactivo()
