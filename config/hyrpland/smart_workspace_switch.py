#!/usr/bin/env python3

import json
import subprocess
import sys

def run(cmd):
    return subprocess.check_output(cmd, shell=True).decode("utf-8").strip()

def get_monitors():
    data = run("hyprctl -j monitors")
    return json.loads(data)

def find_monitor_with_workspace(monitors, ws_id):
    for mon in monitors:
        if mon["activeWorkspace"]["id"] == ws_id:
            return mon
    return None

def main():
    if len(sys.argv) < 2:
        print("Uso: swap_workspace.py <workspace_id>")
        sys.exit(1)

    target_ws = int(sys.argv[1])
    monitors = get_monitors()

    focused_monitor = next((m for m in monitors if m["focused"]), None)
    if not focused_monitor:
        print("No se pudo determinar el monitor con foco.")
        sys.exit(1)

    current_ws = focused_monitor["activeWorkspace"]["id"]
    target_monitor = find_monitor_with_workspace(monitors, target_ws)

    print(f"Monitor con foco: {focused_monitor['name']} (workspace actual: {current_ws})")

    if target_monitor:
        print(f"Workspace solicitado {target_ws} está en monitor: {target_monitor['name']}")
        if target_monitor["name"] == focused_monitor["name"]:
            print("Ya estás en ese workspace en este monitor. No se hace nada.")
            return
        else:
            print(f"Intercambiando workspace {current_ws} con {target_ws}")
            run(f"hyprctl dispatch moveworkspacetomonitor {current_ws} {target_monitor['name']}")
            run(f"hyprctl dispatch moveworkspacetomonitor {target_ws} {focused_monitor['name']}")
            run(f"hyprctl dispatch workspace {target_ws}")
    else:
        print(f"Workspace {target_ws} no está activo en ningún monitor. Moviéndolo al monitor actual.")
        run(f"hyprctl dispatch moveworkspacetomonitor {target_ws} {focused_monitor['name']}")
        run(f"hyprctl dispatch workspace {target_ws}")

if __name__ == "__main__":
    main()
