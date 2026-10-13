# Changesets

Every change that reaches users (a skill, its scripts, the plugin manifest, install steps in the README) ships with a changeset. Add one with `npx changeset`, or write the file by hand:

```md
---
"l0st0-skills": minor
---

shakedown: one or two sentences on what changed for someone using the skill.
```

Bump `minor` for a new skill or behaviour, `patch` for a fix or wording change, `major` for a removed or renamed skill. Changes to this repo's own tooling (CI, `AGENTS.md`) need none.

On merge to `main`, the release workflow opens or updates a "chore: version skills" PR that collects the pending changesets into `CHANGELOG.md` and bumps the version in `package.json` and `.claude-plugin/plugin.json`. Merging that PR tags the release and publishes it on GitHub.
