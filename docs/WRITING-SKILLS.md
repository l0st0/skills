# Writing skills

Read this before editing any `skills/*/SKILL.md`.

Every skill here is written against the `mattpocock-skills:writing-for-agents` standard — invoke that skill first; it carries the general rules. What follows is only what this repo commits to on top of them.

## What the existing prose commits to

- Numbered steps, each closing with an explicit done-criterion sentence.
- Concepts the skill defines are bolded on first use — **personas**, **expected**, the verdicts, the four sections of the project file.
- Dense and non-redundant: no restating, no summary sections, no examples that only illustrate. A line earns its place by carrying a fact the agent cannot derive.
- `verify-in-browser/SKILL.md` stays at or under 40 lines. Something new going in means something else coming out.

## Frontmatter

`description` is a routing decision — it states *when* to reach for the skill, not what it is. That holds for model-invoked skills; a user-invoked skill (`disable-model-invocation: true`) hides its description from the agent, so there it is a human-facing one-line summary instead, trigger lists stripped. `README.md` retells the skill in prose for human readers, and both manifests under `.claude-plugin/` mirror it loosely. Changing a skill's behaviour means checking those.

## The project file

`verify-in-browser` step 2 writes and reads `docs/verify-in-browser.md` in the *consuming* project, never here. Its four sections are defined inline in that step, the single source of truth for the schema.

Step 3 hands sub-agents their rules inline in the dispatch prompt, and nothing of the report step: a walker that can see the report has a way to finish other than walking.

## Per-agent metadata

`skills/<name>/agents/openai.yaml` carries `display_name` and `short_description` for CLI installs into non-Claude agents. A new skill needs one.

## Releasing

`.claude-plugin/marketplace.json` embeds a full copy of the plugin entry from `plugin.json`, `version` included. Bump both or the marketplace advertises a stale version.
