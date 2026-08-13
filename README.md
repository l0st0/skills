# skills

Three agent skills. One works through a queue of tickets while you're away. The other two check a finished change by clicking through the running app instead of reading the diff.

## implement-batch

Point it at your tracker's ready tickets and walk away.

It queues every open ticket labelled `ready-for-agent`, reads them all, and asks you everything they leave open in one pass. That's the last time it needs you at the keyboard. Then it works the queue: build a ticket as one commit, review the commit against the ticket, amend what the review blocks on. A ticket that still fails review is parked on a `failed/<ticket>` branch and its dependents are skipped.

When you come back, you read one table: what landed, what failed, what was flagged but not fixed. Nothing is ever pushed.

Tickets can live anywhere `docs/agents/issue-tracker.md` describes: GitHub, GitLab, Jira, or plain markdown under `.scratch/`. Invoke it by hand as `/implement-batch`; it never triggers itself.

## verify-in-browser

Starts the app and watches the change behave. It derives cases from the spec or the diff, then walks the app once per persona, each with its own browser session and data. A preflight repairs a broken environment instead of reporting it as a finding. Every case comes back pass, observed-vs-expected, or unreached.

## verify-in-browser-setup

Writes the setup file the walk runs on: how to serve the app, what has to be running around it, how to seed data, how each persona signs in, which flows mean the app works. It reads the codebase for those facts and proves each one by running it, asking you only the genuine decisions. You rarely call it yourself; `verify-in-browser` reaches for it when the file is missing or a probe fails.

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

`implement-batch` drives the `code-review` and `tdd` skills from `mattpocock-skills`, which ship separately. Without them its review step has nothing to invoke.

The browser walk needs a way to drive a browser: a browser-automation skill, a browser MCP server, or the project's own end-to-end harness run headed. The setup skill tells you if the session has none.

## License

MIT
