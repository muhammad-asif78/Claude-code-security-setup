# Claude Code Config

This package contains the reusable Claude-side configuration for the repository.

Use it when you want to install:

- Claude settings
- global memory defaults
- reusable commands
- safety hooks
- terminal status helpers

## Included Files

- `settings.json`
  Claude runtime defaults, deny rules, and statusline configuration
- `claude-md-template.md`
  starter content for `~/.claude/CLAUDE.md`
- `commands/`
  reusable command templates for common workflows
- `hooks/`
  shell hooks for safety and automation
- `scripts/statusline.sh`
  a simple terminal statusline helper
- `mcp-template.json`
  starter MCP configuration

## Recommended Install Targets

- `settings.json` -> `~/.claude/settings.json`
- `claude-md-template.md` -> `~/.claude/CLAUDE.md`
- `scripts/statusline.sh` -> `~/.claude/statusline.sh`
- `commands/*.md` -> `~/.claude/commands/`
- `mcp-template.json` -> `~/.mcp.json`

## Suggested Installation Order

1. install `settings.json`
2. install `CLAUDE.md`
3. install `statusline.sh`
4. install command files
5. review hooks before enabling custom behavior

## Notes

- Review all settings before copying them into your personal environment.
- Do not overwrite an existing personalized `CLAUDE.md` without checking it first.
- Keep secrets out of config files and out of git.
