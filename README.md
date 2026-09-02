# skills

Two agent skills. `verify-in-browser` checks a finished change by clicking through the running app instead of reading the diff, and `verify-in-browser-setup` writes the file that walk runs on.

These are built as additions to [Matt Pocock's skills](https://github.com/mattpocock/skills), which I recommend installing first.

`verify-in-browser` is invoke-only — it carries `disable-model-invocation: true`, so an agent never starts a walk on its own; you trigger it by hand as `/verify-in-browser`. The setup skill stays reachable so the walk can run it when the setup file is missing or a probe fails.

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

The browser walk needs a way to drive a browser: a browser-automation skill, a browser MCP server, or the project's own end-to-end harness run headed. The setup skill tells you if the session has none.

## verify-in-browser

Starts the app and watches the change behave. It derives cases from the spec or the diff, then walks the app once per persona, each with its own browser session and data. A preflight repairs a broken environment instead of reporting it as a finding. Every case comes back pass, observed-vs-expected, or unreached.

## verify-in-browser-setup

Writes the setup file the walk runs on: how to serve the app, what has to be running around it, how to seed data, how each persona signs in, which flows prove the app works. It reads the codebase for those facts, proves each one by running it, and asks you only about the genuine decisions. You rarely call it yourself; `verify-in-browser` reaches for it when the file is missing or a probe fails.

## License

MIT
