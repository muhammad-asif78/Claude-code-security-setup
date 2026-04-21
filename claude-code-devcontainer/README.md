# Claude Code Devcontainer

This package contains a small, reusable devcontainer template for running
Claude Code in an isolated workspace.

## Included Files

- `Dockerfile` builds the container image.
- `devcontainer.json` configures the workspace.
- `post_install.py` applies first-run setup.
- `.zshrc` adds shell quality-of-life defaults.
- `install.sh` provides the `devc` helper command.

## Quick Start

```bash
./install.sh self-install

cd /path/to/project
devc .
devc shell
claude
```

## Rebuild

```bash
devc rebuild
```

If Docker mount errors happen on `/mnt/windows/...`, move the project to
`~/src/...` and run the same commands from there.
