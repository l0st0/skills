# skills

Agent skills for the third axis of review: walking a change through the running app in a browser, across every persona, and reporting what it actually does.

A code review reads the diff against standards and spec. These walk the built thing.

## Skills

| Skill | What it does |
| --- | --- |
| [`verify-in-browser`](skills/verify-in-browser/SKILL.md) | Derives cases from the spec or diff, dispatches one walker per persona with its own write lane, and reports pass / observed-vs-expected / unreached. |
| [`verify-in-browser-setup`](skills/verify-in-browser-setup/SKILL.md) | Writes the per-project file the walk runs on — driver, serve command and base URL, seed command, and one signed-in login per persona. Run once per project. |

`verify-in-browser` calls `verify-in-browser-setup` when the setup file is missing, so install both.

## Install

Any agent, via the [skills CLI](https://skills.sh):

```sh
npx skills add l0st0/skills
```

Claude Code, as a plugin:

```
/plugin marketplace add l0st0/skills
/plugin install verify-in-browser@l0st0-skills
```

## Requirements

The walk needs a way to drive a browser — a browser-automation skill, a browser MCP server, or the project's own end-to-end harness run headed. `verify-in-browser-setup` will tell you if the session has none.

## License

MIT
