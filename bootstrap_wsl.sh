#!/usr/bin/env bash
set -euo pipefail

# Ensure non-interactive apt operations
DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND

# Determine privilege mode
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  if ! command -v sudo >/dev/null; then
    echo "sudo required"
    exit 1
  fi
  SUDO="sudo"
fi

# If Ansible is already present, just exit (you'll use ansible-playbook directly)
if command -v ansible-playbook >/dev/null 2>&1; then
  echo "ansible-playbook already installed. Use: ansible-playbook -K wsl-setup.yml"
  exit 0
fi

# Update package lists and install prerequisites
$SUDO apt-get update -y
$SUDO apt-get install -y --no-install-recommends \
  ca-certificates curl gnupg unzip \
  python3 python3-pip python3-venv python3-apt \
  pipx git

# Ensure pipx is on PATH for this shell
export PATH="$HOME/.local/bin:$PATH"

# Install Ansible via pipx (optionally pin version with $ANSIBLE_VERSION)
if [ -n "${ANSIBLE_VERSION:-}" ]; then
  pipx install --include-deps "ansible==${ANSIBLE_VERSION}"
else
  pipx install --include-deps ansible
fi

# Helpful collection (needed for pipx module usage later)
ansible-galaxy collection install community.general

# Run your playbook with bootstrap scripts enabled
hash -r
ansible-playbook -K wsl-setup.yml -e run_bootstrap_scripts=true

echo
echo "Done. New zsh sessions will have pipx on PATH. If you want to refresh the current terminal:"
echo "  exec zsh -l"
