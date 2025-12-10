
#!/usr/bin/env bash
set -euo pipefail

# ---------------------------
# Project Setup Script (idempotent)
# ---------------------------
# What it does:
# - Detects project components and sets them up safely.
# - Python: create venv and pip install if requirements.txt exists
# - Node: npm install if package.json exists
# - Terraform: terraform init if *.tf present
# - Env: copy .env.example to .env if needed
# - Git hooks: install pre-commit if configured
# - Docker: build image if Dockerfile present
#
# Usage:
#   bash ./bin/setup.sh
#
# Re-run safe. Exits on first error (set -e).

# ---- Helper output formatting ----
info()  { echo -e "\033[1;34m[INFO]\033[0m  $*"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m  $*"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $*"; }
ok()    { echo -e "\033[1;32m[OK]\033[0m    $*"; }

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

info "Project root: $PROJECT_ROOT"

# ---- Tool checks (non-fatal where possible) ----
need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    warn "Missing command: $1"
    return 1
  else
    ok "Found $1: $(command -v "$1")"
  fi
}

info "Checking common tooling..."
need_cmd git || true
need_cmd python3 || true
need_cmd pip3 || true
need_cmd node || true
need_cmd npm || true
need_cmd docker || true
need_cmd terraform || true
need_cmd pre-commit || true

# ---- .env setup ----
if [[ -f ".env.example" && ! -f ".env" ]]; then
  info "Creating .env from .env.example"
  cp .env.example .env
  ok ".env created"
