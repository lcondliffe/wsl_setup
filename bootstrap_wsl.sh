#!/usr/bin/env bash
set -euo pipefail

# If Ansible is already present, just exit (you'll use ansible-playbook directly)
if command -v ansible-playbook >/dev/null 2>&1; then
  echo "ansible-playbook already installed. Use: ansible-playbook -K wsl-setup.yml"
  exit 0
fi

sudo apt-get update -y
sudo apt-get install -y python3 python3-pip python3-venv pipx git curl unzip

# Ensure pipx is on PATH
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH

# Install Ansible via pipx
pipx install --include-deps ansible

# Helpful collection (needed for pipx module usage later)
ansible-galaxy collection install community.general

# Run your playbook with bootstrap scripts enabled
hash -r
ansible-playbook -K wsl-setup.yml -e run_bootstrap_scripts=true

echo
echo "Done. New zsh sessions will have pipx on PATH. If you want to refresh the current terminal:"
echo "  exec zsh -l"