# skills

Agent skills for building a ticket queue and for the third axis of review: walking a change through the running app in a browser.

A code review reads the diff against standards and spec. The browser walk runs against branch changes, a PR, or a full application smoke.

## Skills

| Skill | What it does |
| --- | --- |
| [`implement-batch`](skills/implement-batch/SKILL.md) | Implements a queue of tracker tickets one at a time — a pre-flight asks whatever the tickets leave open, a subagent builds each, you review it, a second subagent fixes what blocks. Never pushes. |
| [`verify-in-browser`](skills/verify-in-browser/SKILL.md) | Derives cases from the spec or diff, dispatches one walker per persona with its own write lane, and reports pass / observed-vs-expected / unreached. |
| [`verify-in-browser-setup`](skills/verify-in-browser-setup/SKILL.md) | Builds or repairs the per-project file the walk runs on — driver, serve command and base URL, seed command, where per-walk fixtures live, and one signed-in login per persona. |

`verify-in-browser` calls `verify-in-browser-setup` when the setup file is missing, so install both.

`implement-batch` is invoked by hand as `/implement-batch`; it never routes itself.

## Install

Any agent, via the [skills CLI](https://skills.sh):

```sh
npx skills add l0st0/skills
```

Claude Code, as a plugin:

```
/plugin marketplace add l0st0/skills
/plugin install l0st0-skills@l0st0
```

## Requirements

`implement-batch` calls the `code-review` and `tdd` skills, which ship separately (`mattpocock-skills`). Without them its review step has nothing to invoke.

The walk needs a way to drive a browser — a browser-automation skill, a browser MCP server, or the project's own end-to-end harness run headed. `verify-in-browser-setup` will tell you if the session has none.

## License

MIT
