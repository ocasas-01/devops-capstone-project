#!/bin/bash

echo "Checking required tools..."

check_command() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "[OK] Found $1: $(command -v $1)"
  else
    echo "[WARN] Missing command: $1"
  fi
}

check_command git
check_command python3
check_command pip3
check_command node
check_command npm
check_command docker
check_command terraform
check_command pre-commit

echo "Setting up environment..."

if [ ! -f .env ]; then
  echo "Creating .env file..."
  cat <<EOF > .env
DATABASE_URL=postgres://postgres:postgres@localhost:5432/testdb
SECRET_KEY=your_secret_key
EOF
else
  echo ".env file already exists."
fi

echo "Setup complete."

