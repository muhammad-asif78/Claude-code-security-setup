# Trail of Bits Setup Security

![GPG Signed](https://img.shields.io/badge/commits-GPG%20signed-brightgreen?logo=git&style=for-the-badge)

Opinionated defaults, documentation, and workflows for Claude Code in a safer,
more structured environment inspired by Trail of Bits practices.

This repository combines two related pieces in one clean place:

- `claude-code-devcontainer`
- `claude-code-config`

The goal is to give you:

- a reusable devcontainer workflow for isolated Claude sessions
- a reusable Claude config package for settings, hooks, commands, and memory
- a documented setup path that is easier to follow than an ad hoc local setup

Also see the package-level guides:

- `claude-code-devcontainer/README.md`
- `claude-code-config/README.md`
- `docs/setup-guide.md`

## First-Time Setup

Start inside this repository:

```bash
cd trailofbits-setup-security
```

Then follow this order:

```bash
# 1. Install the Dev Containers CLI
npm install -g @devcontainers/cli

# 2. Install the devc helper from this repo
cd claude-code-devcontainer
./install.sh self-install

# 3. Optionally install Claude config files
cd ..
mkdir -p ~/.claude ~/.claude/commands
cp claude-code-config/settings.json ~/.claude/settings.json
cp claude-code-config/claude-md-template.md ~/.claude/CLAUDE.md
cp claude-code-config/scripts/statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
cp claude-code-config/commands/review-pr.md ~/.claude/commands/
cp claude-code-config/commands/fix-issue.md ~/.claude/commands/
cp claude-code-config/commands/merge-dependabot.md ~/.claude/commands/
cp claude-code-config/mcp-template.json ~/.mcp.json
```

Then move to the project you want to run in a container:

```bash
cd /path/to/your/project
devc .
devc shell
claude
```

If `.devcontainer/` already exists in the target project, use `devc up` instead
of `devc .`.

## Contents

**Getting Started**

- Read These First
- Repository Purpose
- Prerequisites
- Recommended Tools
- Shell Setup
- Installing the Devcontainer Helper
- Installing Claude Config Files

**Configuration**

- Sandboxing
- Devcontainer
- Claude Settings
- Global `CLAUDE.md`
- Hooks
- MCP Servers
- Local Models
- Personalization

**Usage**

- Starting a Project Container
- Rebuilding
- Running Claude
- Project-level `CLAUDE.md`
- Context Management
- Commands
- Troubleshooting

## Getting Started

### Read These First

Before configuring anything, it helps to understand the mindset behind this
kind of setup:

- Claude Code works best when the environment is deliberate and repeatable
- unrestricted agents should be paired with sandboxing or isolation
- reusable instructions belong in config files, not in random conversations
- safe defaults reduce avoidable mistakes during long autonomous sessions

This repository is designed around those ideas.

### Repository Purpose

This repo is split into two packages:

- `claude-code-devcontainer`
  builds and manages the isolated container workflow
- `claude-code-config`
  stores reusable Claude settings, hooks, commands, statusline, and templates

Use `claude-code-devcontainer` when you want to start a safe project
environment.

Use `claude-code-config` when you want to install reusable Claude defaults into
your own home directory.

### Prerequisites

#### Docker Runtime

Install one of the following:

- Docker Desktop
- OrbStack
- Colima

Docker must be running before `devc` can start or rebuild containers.

#### Dev Containers CLI

Install:

```bash
npm install -g @devcontainers/cli
```

### Recommended Tools

If you are using Homebrew, these are good baseline tools:

```bash
brew install jq ripgrep fd ast-grep shellcheck shfmt \
  actionlint zizmor node@22 pnpm uv
```

If you are on Linux or WSL, install equivalent packages with your package
manager.

#### Python Tools

```bash
uv tool install ruff
uv tool install ty
uv tool install pip-audit
```

#### Rust Toolchain

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install prek worktrunk cargo-deny cargo-careful
```

#### Node Tools

```bash
npm install -g oxlint agent-browser
```

#### Local Models

If you want local model support:

```bash
curl -fsSL https://lmstudio.ai/install.sh | bash
```

### Shell Setup

Add this to your `~/.zshrc` if you want a fast alias:

```bash
alias claude-yolo="claude --dangerously-skip-permissions"
```

`--dangerously-skip-permissions` removes permission prompts. Use it with
sandboxing or devcontainers, not casually on a sensitive host machine.

If you use local models, you can also add:

```bash
claude-local() {
  ANTHROPIC_BASE_URL=http://localhost:1234 \
  ANTHROPIC_AUTH_TOKEN=lmstudio \
  CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
  claude --model qwen/qwen3-coder-next "$@"
}
```

### Installing the Devcontainer Helper

Move into the devcontainer package and install the helper:

```bash
cd claude-code-devcontainer
./install.sh self-install
```

This installs:

```bash
~/.local/bin/devc
```

If needed, add it to your `PATH`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### Installing Claude Config Files

The config package contains:

- `settings.json`
- `claude-md-template.md`
- `mcp-template.json`
- `commands/`
- `hooks/`
- `scripts/statusline.sh`

Install the pieces you want manually.

#### Settings

```bash
mkdir -p ~/.claude
cp claude-code-config/settings.json ~/.claude/settings.json
```

#### Global `CLAUDE.md`

```bash
cp claude-code-config/claude-md-template.md ~/.claude/CLAUDE.md
```

#### Statusline

```bash
mkdir -p ~/.claude
cp claude-code-config/scripts/statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

#### Commands

```bash
mkdir -p ~/.claude/commands
cp claude-code-config/commands/review-pr.md ~/.claude/commands/
cp claude-code-config/commands/fix-issue.md ~/.claude/commands/
cp claude-code-config/commands/merge-dependabot.md ~/.claude/commands/
```

#### MCP Template

```bash
cp claude-code-config/mcp-template.json ~/.mcp.json
```

Review everything before using it in your personal environment.

## Configuration

### Sandboxing

This setup is built around the idea that strong agent autonomy should be paired
with isolation.

There are two main approaches:

- built-in Claude sandboxing
- devcontainers

Built-in sandboxing is useful, but a devcontainer gives you stronger filesystem
isolation for project work.

### Devcontainer

The devcontainer package provides:

- `Dockerfile`
- `devcontainer.json`
- `.zshrc`
- `post_install.py`
- `install.sh`

The intended flow is:

```bash
cd /path/to/project
devc .
devc shell
claude
```

If the project already contains a `.devcontainer/`, use:

```bash
devc up
```

If you change the Dockerfile or devcontainer config:

```bash
devc rebuild
```

### Claude Settings

The included `settings.json` is meant as a reusable starter.

It includes examples of:

- telemetry disabling
- error reporting disabling
- long conversation retention
- deny rules for secrets and sensitive files
- statusline configuration
- simple Bash guardrails

### Global `CLAUDE.md`

The included `claude-md-template.md` is a starter memory file for:

- coding style defaults
- safety conventions
- tool preferences
- reusable session instructions

Customize it after copying it into `~/.claude/CLAUDE.md`.

### Hooks

Hooks let you intercept or react to Claude tool events.

This repo includes examples such as:

- enforcing the package manager
- logging command activity

Use hooks as guardrails, not as a hard security boundary.

### MCP Servers

The repo includes a starter `mcp-template.json` file.

Use it as a base for:

- documentation lookup servers
- search servers
- project-specific servers

Do not blindly enable MCP servers from untrusted repositories.

### Local Models

If you use LM Studio or a compatible local server, the shell helper example in
the Shell Setup section shows how to point Claude Code at a local endpoint.

### Personalization

Once the basic setup is working, personalize:

- your global `CLAUDE.md`
- your statusline
- your command templates
- your hooks

The important thing is to make changes deliberately rather than piling random
instructions into one session.

## Usage

### Starting a Project Container

For a new project:

```bash
cd /path/to/project
devc .
```

For an existing `.devcontainer/`:

```bash
cd /path/to/project
devc up
```

### Rebuilding

```bash
devc rebuild
```

Use this after changing:

- `Dockerfile`
- `devcontainer.json`
- `post_install.py`
- `.zshrc`

### Running Claude

After entering the container:

```bash
devc shell
claude
```

The expected environment is:

- user: `vscode`
- workspace: `/workspace`

### Project-level `CLAUDE.md`

Each project should ideally have its own `CLAUDE.md` at repo root with:

- project architecture notes
- test commands
- build commands
- codebase-specific conventions
- important gotchas

Global config should hold your defaults.
Project `CLAUDE.md` should hold project-specific context.

### Context Management

Keep sessions clean:

- prefer one task per session
- use fresh sessions when context gets noisy
- store stable reusable rules in `CLAUDE.md`
- avoid dragging long stale conversations across unrelated tasks

### Commands

The included command templates are meant to be copied into:

```bash
~/.claude/commands/
```

They give you reusable flows for things like:

- PR review
- issue fixing
- dependabot merges

## Security Notes

Do not commit secrets into this repository.

This repo ignores:

- `.env`
- `.env.*`
- `*.pem`
- `*.key`
- `*.p12`
- `*.pfx`
- `secrets/`

Use `.env.example` if you want to document required environment variables
without leaking real values.

Avoid mounting large sensitive host directories into containers unless you fully
understand the tradeoff.

## Troubleshooting

### `devcontainer` CLI not found

```bash
npm install -g @devcontainers/cli
```

### Docker mount errors

If bind mounts fail from `/mnt/windows/...`, use a Linux-native or WSL-native
path such as:

```bash
~/src/project-name
```

### Container does not start

Try:

```bash
devc rebuild
```

Also check:

- Docker is running
- the project path exists
- your host `.gitconfig` file exists

### `devc shell` says container not found

Make sure you started the project first:

```bash
devc up
```

or:

```bash
devc .
```

## Where To Start

If you want the simplest beginner order, use this:

1. install Docker
2. install Node and `@devcontainers/cli`
3. install `devc` from `claude-code-devcontainer`
4. copy the Claude config files you want from `claude-code-config`
5. move into the target project
6. run `devc .`
7. run `devc shell`
8. run `claude`

For a shorter operational guide, also read [docs/setup-guide.md](docs/setup-guide.md).
