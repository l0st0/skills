# Writing skills

Read this before editing any `skills/*/SKILL.md`.

Every skill here is written against the `mattpocock-skills:writing-for-agents` standard — invoke that skill first; it carries the general rules. What follows is only what this repo commits to on top of them.

## What the existing prose commits to

- Numbered steps, each closing with an explicit done-criterion sentence.
- Concepts the skill defines are bolded on first use — **oracle**, **lane**, **fixture**, **driver**, **axis**.
- Dense and non-redundant: no restating, no summary sections, no examples that only illustrate. A line earns its place by carrying a fact the agent cannot derive.

## Frontmatter

`description` is a routing decision — it states *when* to reach for the skill, not what it is. `README.md` retells each skill in prose for human readers, and both manifests under `.claude-plugin/` mirror it loosely. Changing a skill's behaviour means checking those.

## The two skills are coupled

`verify-in-browser` step 2 reads the setup file that `verify-in-browser-setup` step 6 writes. Its section list lives once, in `verify-in-browser-setup/TEMPLATE.md` — edit the schema there, never in either skill's prose. That file lives in the *consuming* project — at the path its `AGENTS.md`/`CLAUDE.md` names, or `.claude/verify-in-browser.md` — never here.

`verify-in-browser` step 3 hands `WALKER.md` to sub-agents verbatim. That file is walker-facing only: it is the single source of truth for the verdicts, and the report step must never leak into it — a walker that can see the report has a way to finish other than walking.

## Per-agent metadata

`skills/<name>/agents/openai.yaml` carries `display_name` and `short_description` for CLI installs into non-Claude agents. A new skill needs one.

## Releasing

`.claude-plugin/marketplace.json` embeds a full copy of the plugin entry from `plugin.json`, `version` included. Bump both or the marketplace advertises a stale version.
