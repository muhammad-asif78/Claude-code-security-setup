# Claude Defaults

## Working Style

- Prefer small, reviewable changes.
- Verify behavior with tests when possible.
- Explain tradeoffs briefly and clearly.

## Safety

- Do not use destructive commands without approval.
- Avoid editing secrets, shell rc files, or auth material.
- Prefer isolated containers for untrusted code.

## Tooling

- Python: `uv`, `ruff`
- Node: `pnpm` or the package manager already used by the repo
- Search: `rg`
- Formatting: project-native formatter first
