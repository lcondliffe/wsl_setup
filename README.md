# WSL Terminal Setup

Reproducible setup for a WSL (Ubuntu). The goal is to keep the machine as close to ephemeral as possible so rebuilds or distro upgrades are fast: re-run the playbook and you’re back in a working state.

## Usage 

`ansible-playbook -K wsl-setup.yml`

- Targeted runs with tags (faster, incremental):
  - apt only: ansible-playbook -K wsl-setup.yml -t apt
  - terraform only: ansible-playbook -K wsl-setup.yml -t terraform
  - env vars only: ansible-playbook -K wsl-setup.yml -t env
  - shell/aliases only: ansible-playbook -K wsl-setup.yml -t aliases,shell