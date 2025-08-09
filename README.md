# WSL Terminal Setup

Reproducible setup for a WSL (Ubuntu). The goal is to keep the machine as close to ephemeral as possible so rebuilds or distro upgrades are fast: re-run the playbook and you’re back in a working state.

## Usage 

`ansible-playbook -K wsl-setup.yml`

- Targeted runs with tags (faster, incremental):
  - apt only: `ansible-playbook -K wsl-setup.yml -t apt`
  - terraform only: `ansible-playbook -K wsl-setup.yml -t terraform`
  - env vars only: `ansible-playbook -K wsl-setup.yml -t env`
  - shell/aliases only: `ansible-playbook -K wsl-setup.yml -t aliases,shell`

## Testing

Validate the playbook locally in a container:

```
# Run playbook in ephemeral Ubuntu container
podman run --rm -v "$(pwd)":/work:Z -w /work docker.io/library/ubuntu:22.04 bash -lc '
  set -euo pipefail
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y --no-install-recommends sudo python3 python3-apt python3-pip curl gpg unzip ca-certificates gnupg
  python3 -m pip install --no-cache-dir ansible
  ansible-playbook -vv wsl-setup.yml
'
```
