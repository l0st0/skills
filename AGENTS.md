The same tree ships two ways: the [skills CLI](https://skills.sh), which reads `skills/*/SKILL.md` directly, and as a Claude Code plugin via `.claude-plugin/`.

A release bumps `version` in `.claude-plugin/plugin.json`: plugin installs update only when it changes.
