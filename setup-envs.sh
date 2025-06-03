#!/usr/bin/env bash

if ! command -v uv >/dev/null 2>&1; then
    echo "uv is not installed. Please install it from https://docs.astral.sh/uv/getting-started/installation/"
    echo "or just run this if you are a very trusting person:"
    echo "'curl -LsSf https://astral.sh/uv/install.sh | sh'"
    exit 1
fi

set -euo pipefail

function log() {
    echo "+> $1" >&2
}

project_root="$(dirname "$(realpath "$0")")"

function setup_venv() {
    local name=$1
    (
        log "Setting up $name"
        [[ -d $name ]] && cd $project_root/$name || {
            log "$name directory not found in $PWD"
            exit 1
        }

        log "Current directory: $PWD"

        [[ -d .venv ]] && {
            log "Removing existing venv at $PWD/.venv"
            rm -rf .venv
        }

        log "Running uv sync in $name"
        uv sync || {
            log "Failed to uv sync in $name"
            exit 1
        }

        [[ -d .venv ]] && log "venv found at $PWD/.venv" || {
            log "$name venv not found"
            exit 1
        }
        log "Python version: $(.venv/bin/python --version)"
        log "$name venv setup complete"
    )
}

log "Setting up environments"

setup_venv no-pyright-venv-config "no-pyright-venv-config"
setup_venv pyright-venv-config "pyright-venv-config"

log "Setup complete"
