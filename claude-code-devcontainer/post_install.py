#!/usr/bin/env python3
"""Minimal first-run setup for the devcontainer."""

from __future__ import annotations

import json
import os
from pathlib import Path


def write_claude_settings() -> None:
    config_dir = Path(os.environ.get("CLAUDE_CONFIG_DIR", Path.home() / ".claude"))
    config_dir.mkdir(parents=True, exist_ok=True)

    settings_path = config_dir / "settings.json"
    data: dict[str, object] = {}

    if settings_path.exists():
      try:
        data = json.loads(settings_path.read_text(encoding="utf-8"))
      except json.JSONDecodeError:
        data = {}

    permissions = data.setdefault("permissions", {})
    if isinstance(permissions, dict):
        permissions["defaultMode"] = "bypassPermissions"

    settings_path.write_text(
        json.dumps(data, indent=2) + "\n",
        encoding="utf-8",
    )


def write_tmux_config() -> None:
    tmux_path = Path.home() / ".tmux.conf"
    if tmux_path.exists():
        return

    tmux_path.write_text(
        "\n".join(
            [
                "set-option -g history-limit 200000",
                "set -g mouse on",
                "setw -g mode-keys vi",
                "set -g base-index 1",
                "setw -g pane-base-index 1",
            ]
        )
        + "\n",
        encoding="utf-8",
    )


if __name__ == "__main__":
    write_claude_settings()
    write_tmux_config()
