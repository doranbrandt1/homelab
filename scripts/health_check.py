#!/usr/bin/env python3

# --- Imports ---
import socket                      # For checking open TCP ports
from rich.console import Console  # Rich console formatting
from rich.table import Table      # Rich table formatting
from datetime import datetime     # For timestamping
import json                       # For saving logs
import os                         # For checking file existence

# --- Service Definitions ---
# Each service has a name, internal Docker IP, port, and its .local alias
services = [
    {
        "name": "jellyfin",
        "ip": "172.24.0.5",
        "port": 8096,
        "alias": "jellyfin.local"
    },
    {
        "name": "homeassistant",
        "ip": "172.24.0.8",
        "port": 8123,
        "alias": "homeassistant.local"
    }
]

# --- Health Check Function ---
# Attempts to connect to each service IP + port using sockets
def check_port_open(host, port):
    try:
        with socket.create_connection((host, port), timeout=1):
            return True
    except (socket.timeout, socket.error):
        return False

# --- Main Display and Logging Logic ---
def main():
    console = Console()
    table = Table(title="Homelab Service Health Check")
    
    table.add_column("Service", style="cyan", no_wrap=True)
    table.add_column("IP", style="magenta")
    table.add_column("Port", justify="right")
    table.add_column("Alias", style="green")
    table.add_column("Status", style="bold")

    # Load or initialize the log
    log_file = "health_status.json"
    if os.path.exists(log_file):
        with open(log_file, "r") as f:
            logs = json.load(f)
    else:
        logs = []

    # Loop through each service and check its status
    for svc in services:
        healthy = check_port_open(svc["ip"], svc["port"])
        status_str = "[green]✅ Healthy[/green]" if healthy else "[red]❌ Down[/red]"
        table.add_row(svc["name"], svc["ip"], str(svc["port"]), svc["alias"], status_str)

        # Append status entry to JSON log
        status_entry = {
            "service": svc["name"],
            "ip": svc["ip"],
            "port": svc["port"],
            "alias": svc["alias"],
            "status": "Healthy" if healthy else "Down",
            "timestamp": datetime.now().isoformat()
        }
        logs.append(status_entry)

    # Write the full updated log back to file
    with open(log_file, "w") as f:
        json.dump(logs, f, indent=2)

    # Print the status table
    console.print(table)

# --- Entry Point ---
if __name__ == "__main__":
    main()
