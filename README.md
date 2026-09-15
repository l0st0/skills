# skills

One agent skill. `verify-in-browser` checks a finished change by clicking through the running app instead of reading the diff.

It is built as an addition to [Matt Pocock's skills](https://github.com/mattpocock/skills), which I recommend installing first.

The skill is invoke-only — it carries `disable-model-invocation: true`, so an agent never starts a walk on its own; you trigger it by hand as `/verify-in-browser`.

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

The walk needs a way to drive a browser: a browser-automation skill, a browser MCP server, or the project's own end-to-end harness run headed.

## verify-in-browser

Hand it a spec, a PR, a branch, or a sentence. It derives cases with an expected result each, names the personas the change touches, starts the app, seeds data, signs in, and dispatches one sub-agent per persona to walk the cases. Every case comes back pass, observed-vs-expected, or unreached.

The first run writes `docs/verify-in-browser.md` in your project: how to serve the app, who the personas are and how they sign in, how data is seeded, and the gotchas no config confesses. Later runs read it and repair any fact that stopped being true.

## License

MIT
