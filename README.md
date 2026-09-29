# skills

One agent skill. `shakedown` checks a finished change by running it — in the browser, against the API, in the database, wherever the change shows — instead of reading the diff.

It is built as an addition to [Matt Pocock's skills](https://github.com/mattpocock/skills), which I recommend installing first. Run it last, after `code-review`.

The skill is invoke-only — it carries `disable-model-invocation: true`, so an agent never starts a shakedown on its own; you trigger it by hand as `/shakedown`.

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

Browser cases need a way to drive a browser: a browser-automation skill, a browser MCP server, or the project's own end-to-end harness run headed.

## shakedown

Hand it a spec, a PR, a branch, or a sentence. It derives cases with an expected result each, names the personas the change touches and the surface each case is observed on, starts the app locally, seeds data, signs in, and dispatches one sub-agent per persona to walk the cases. Every case comes back pass, observed-vs-expected, or unreached. Given a spec, the report ends on a table of every acceptance criterion against its verdicts.

The first run sets up local testing with you: it sweeps the repo for what it can find, asks you the decisions it cannot make — how to seed, which stand-in catches outbound email — proves each by running it, and commits `docs/local-testing.md` with any setup files. Later runs read that guide and repair any fact that stopped being true.

## License

MIT
