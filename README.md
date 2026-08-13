# skills

Four agent skills. `implement-batch` works through a queue of tickets while you're away. `bump-deps` keeps your dependencies current without gambling on the risky ones. `verify-in-browser` and its setup skill check a finished change by clicking through the running app instead of reading the diff.

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

`implement-batch` drives the `code-review` and `tdd` skills from `mattpocock-skills`, which ship separately. Without them its review step has nothing to invoke. `bump-deps` uses the `research` skill from the same suite when it's present, and falls back to researching inline when it isn't.

The browser walk needs a way to drive a browser: a browser-automation skill, a browser MCP server, or the project's own end-to-end harness run headed. The setup skill tells you if the session has none.

## implement-batch

Point it at your tracker's ready tickets and walk away.

It queues every open ticket labelled `ready-for-agent`, reads them all, and asks you everything they leave open in one pass. That's the last time it needs you at the keyboard. Then it works the queue: it builds each ticket as one commit, reviews the commit against the ticket, and amends the commit to fix whatever the review blocks on. A ticket that still fails review is parked on a `failed/<ticket>` branch and its dependents are skipped.

When you come back, you read one table: what landed, what failed, what was flagged but not fixed. Nothing is ever pushed.

Tickets can live anywhere `docs/agents/issue-tracker.md` describes: GitHub, GitLab, Jira, or plain markdown under `.scratch/`. Invoke it by hand as `/implement-batch`; it never triggers itself.

## bump-deps

Audits your direct dependencies and splits them by risk.

Patch and minor bumps go into one batch. Majors and 0.x bumps get their breaking changes researched against your codebase first; the harmless ones join the batch too. It stops once, so you can confirm the batch and settle any open decisions. The batch lands as one commit on a `deps/` branch and has to pass your project's checks. A package that breaks them, or any upgrade that means real work, becomes a tracker ticket with the research linked, ready for `implement-batch` to pick up.

It never pushes and never starts the app. Runtime testing stays yours. Invoke it by hand as `/bump-deps`; it never triggers itself.

## verify-in-browser

Starts the app and watches the change behave. It derives cases from the spec or the diff, then walks the app once per persona, each with its own browser session and data. A preflight repairs a broken environment instead of reporting it as a finding. Every case comes back pass, observed-vs-expected, or unreached.

## verify-in-browser-setup

Writes the setup file the walk runs on: how to serve the app, what has to be running around it, how to seed data, how each persona signs in, which flows prove the app works. It reads the codebase for those facts, proves each one by running it, and asks you only about the genuine decisions. You rarely call it yourself; `verify-in-browser` reaches for it when the file is missing or a probe fails.

## License

MIT
