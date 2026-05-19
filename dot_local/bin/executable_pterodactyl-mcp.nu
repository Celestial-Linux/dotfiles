#!/usr/bin/env nu

def --wrapped main [...args: string] {
    cd /var/home/celeste/Documents/Development/CelesteLove/PterodactylMCP
    ^uv run --with-requirements requirements.txt python run_server.py --no-banner ...$args
}
