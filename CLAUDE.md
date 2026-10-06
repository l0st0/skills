# CLAUDE.md

The same tree ships two ways: the [skills CLI](https://skills.sh), which reads `skills/*/SKILL.md` directly, and as a Claude Code plugin via `.claude-plugin/`.

`.claude-plugin/marketplace.json` embeds a copy of the plugin entry from `plugin.json`, `version` included: a release bumps both.
