# skills

Three agent skills. One works through a queue of tickets while you're away. The other two check a finished change by clicking through the running app instead of reading the diff.

## implement-batch

Point it at a folder of tickets and walk away.

Before it starts, it reads every ticket and asks you everything they leave open in one pass. That's the last time it needs you at the keyboard. Then, ticket by ticket: a builder subagent implements the work as a single commit, the commit gets a code review against the ticket, and a fixer subagent amends whatever the review blocks on. A ticket that still fails review after one fix round is parked on a `failed/<ticket>` branch, tickets that depended on it are skipped, and the queue moves on.

Every ticket gets a row in a run log as the run goes, so when you come back you read one table: what landed, what failed, what got flagged but not fixed. Nothing is ever pushed.

Invoke it by hand as `/implement-batch`; it never triggers itself.

## verify-in-browser

A code review reads the diff. This skill starts the app and watches the change behave.

It derives its cases from the spec or the diff, then walks the app once per persona, each walker in its own browser session with its own data so they don't trample each other. Each case comes back with one of three verdicts: pass, observed-vs-expected when the app did something else, or unreached when the walk couldn't get there.

## verify-in-browser-setup

The walk needs project specifics: how to serve the app, the base URL, how to seed data, how each persona signs in. This skill builds that setup file and repairs it when it drifts. You rarely call it yourself; `verify-in-browser` reaches for it when the file is missing.

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

`implement-batch` drives the `code-review` and `tdd` skills from `mattpocock-skills`, which ship separately. Install those too, or its review step has nothing to invoke.

The browser walk needs a way to drive a browser: a browser-automation skill, a browser MCP server, or the project's own end-to-end harness run headed. The setup skill tells you if the session has none.

## License

MIT
