# Claude Code Integration

This DDEV project ships with a sandboxed [Claude Code](https://claude.ai/code) setup so AI-assisted development works inside the DDEV web container without polluting the host system.

## Prerequisites

1. A Claude Code subscription (Pro or Max plan)
2. An Anthropic API token — set it in `.ddev/config.claude-code.local.yaml`:

```yaml
web_environment:
  - 'ANTHROPIC_AUTH_TOKEN=<your-token>'
  ## Optional: use a proxy
  # - 'ANTHROPIC_BASE_URL=https://<your_proxy>'
```

> **Never commit `.ddev/config.claude-code.local.yaml`.** It contains credentials.

## Usage

```bash
ddev claude       # Start an interactive Claude Code session inside the container
```

## How it works

### Installation & binary persistence

On `ddev start`, the `post-start` hooks in `.ddev/config.claude-code.yaml` automatically install Claude Code if not present:

```
curl -fsSL https://claude.ai/install.sh | bash -s stable
```

The binary is stored in `.ddev/claude-code/.local/bin/` on the host, which persists across container rebuilds — avoiding a ~213 MB re-download on every `ddev start`.

### Symlinks instead of bind mounts

Since single-file bind mounts inside DDEV containers are unreliable, the `post-start` hooks use symlinks to wire the host paths into the container:

| Host path (persisted)                    | Container path (symlink) |
|------------------------------------------|--------------------------|
| `.ddev/claude-code/.claude.json`         | `~/.claude.json`         |
| `.ddev/claude-code/.claude/`             | `~/.claude/`             |
| `.ddev/claude-code/.local/bin/`          | `~/.local/bin/`          |
| `.ddev/claude-code/.local/share/claude/` | `~/.local/share/claude/` |
| `.ddev/claude-code/.local/state/claude/` | `~/.local/state/claude/` |

`$PATH` is extended via `.ddev/homeadditions/.bashrc.d/path.sh`.

### System packages

`.ddev/config.claude-code.yaml` installs all required system packages via `webimage_extra_packages` on container start.

### Updating Claude Code

```bash
ddev claude upgrade
```

See the [official update guide](https://code.claude.com/docs/en/setup#update-claude-code) for more details.

## What NOT to commit

| Path                                  | Reason                        |
|---------------------------------------|-------------------------------|
| `.ddev/config.claude-code.local.yaml` | Contains your API token       |
| `.ddev/claude-code/config/`           | Personal Claude Code settings |

Only commit parts of `.ddev/claude-code/` if your team explicitly benefits from shared configuration.
