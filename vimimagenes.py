#!/bin/python3
import os
import subprocess
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
    import re
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
                print("  a / Enter → aceptar")
                print("  s         → saltar")
                print("  w+ / w-   → ancho + / -")
                print("  h+ / h-   → alto + / -")
                print("  q         → salir")

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
                elif opt == "w+":
                    sugerido_w += 1
                elif opt == "w-":
                    sugerido_w = max(MIN_WIDTH, sugerido_w - 1)
                elif opt == "h+":
                    sugerido_h += 1
                elif opt == "h-":
                    sugerido_h = max(MIN_HEIGHT, sugerido_h - 1)
                else:
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
