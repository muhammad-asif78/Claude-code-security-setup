# Setup Guide

This project is split into two clean pieces:

1. `claude-code-devcontainer`
2. `claude-code-config`

## Why This Layout

- Devcontainer files stay isolated from Claude config files.
- Docs are easy to find under `docs/`.
- Commands, hooks, and scripts are grouped by purpose.
- The root folder stays readable and easy to navigate.

## Typical Usage

### 1. Install the helper

```bash
cd claude-code-devcontainer
./install.sh self-install
```

### 2. Start a project container

```bash
cd /path/to/project
devc .
devc shell
```

### 3. Start Claude inside the container

```bash
claude
```

## Important Notes

- Use `devc .` only for first-time setup in a project.
- Use `devc up` when `.devcontainer/` already exists.
- Use `devc rebuild` when you change the Dockerfile or devcontainer config.
- Prefer a Linux or WSL-native path like `~/src/project` instead of `/mnt/windows/...`
  when Docker bind mounts are failing.

## Example Project Layout

```text
client-audit/
├── .devcontainer/
│   ├── Dockerfile
│   ├── devcontainer.json
│   ├── post_install.py
│   └── .zshrc
├── app/
├── tests/
└── README.md
```
