# WSL Terminal Setup

Reproducible setup for a WSL (Ubuntu). The goal is to keep the machine as close to ephemeral as possible so rebuilds or distro upgrades are fast: re-run the playbook and you're back in a working state.

## Configuration

Default configuration is stored in `vars.yml` and includes:
- Package lists (apt packages, shell aliases)
- Directory structure
- Tool versions (Terraform, etc.)
- Environment variables

You can customize the setup by:
1. Editing `vars.yml` directly
2. Using a custom vars file: `ansible-playbook -K wsl-setup.yml -e @my-vars.yml`
3. Overriding specific variables: `ansible-playbook -K wsl-setup.yml -e terraform_version=1.10.0`

## Usage 

`ansible-playbook -K wsl-setup.yml`

- Targeted runs with tags (faster, incremental):
  - apt only: `ansible-playbook -K wsl-setup.yml -t apt`
  - terraform only: `ansible-playbook -K wsl-setup.yml -t terraform`
  - env vars only: `ansible-playbook -K wsl-setup.yml -t env`
  - shell/aliases only: `ansible-playbook -K wsl-setup.yml -t aliases,shell`

## Testing

Validate the playbook locally in a container:

```bash
# Quick validation (auto-removes container)
podman run --rm -v "$(pwd)":/work:Z -w /work docker.io/library/ubuntu:24.04 \
  bash -lc './bootstrap_wsl.sh'

# Interactive testing (keeps container for inspection)
podman run -it -v "$(pwd)":/work:Z -w /work docker.io/library/ubuntu:24.04 \
  bash -c './bootstrap_wsl.sh; exec zsh'

# Ubuntu 22.04
podman run --rm -v "$(pwd)":/work:Z -w /work docker.io/library/ubuntu:22.04 \
  bash -lc './bootstrap_wsl.sh'

# Install a specific Ansible version
ANSIBLE_VERSION=9.5.1 podman run --rm -v "$(pwd)":/work:Z -w /work \
  docker.io/library/ubuntu:24.04 \
  bash -lc 'ANSIBLE_VERSION="$ANSIBLE_VERSION" ./bootstrap_wsl.sh'
```
