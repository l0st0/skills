# skills

Three agent skills. One works through a queue of tickets while you're away. The other two check a finished change by clicking through the running app instead of reading the diff.

## implement-batch

Point it at your tracker's ready tickets and walk away.

Tickets can live anywhere the repo's `docs/agents/issue-tracker.md` describes: GitHub issues, GitLab, a Jira workflow you wrote down, or plain markdown files under `.scratch/`. Run it with no arguments and it queues every open ticket labelled `ready-for-agent`, ordered so blocking work builds first. A ticket that depends on something unfinished outside the queue gets skipped instead of built on missing work.

Before anything builds, it reads every ticket and asks you everything they leave open, in one pass. That's the last time it needs you at the keyboard. Your answers are posted back onto the tickets, so the reviewer later reads the same spec the builder did.

Then it works the queue one ticket at a time. A builder subagent implements the ticket as a single commit. The commit gets a code review against the ticket. A fixer subagent amends whatever the review blocks on: a broken repo standard, a missed requirement, or a demonstrated bug. A ticket that still fails review after one fix round is parked on a `failed/<ticket>` branch, its dependents are skipped, and the queue moves on.

Every ticket gets a row in a run log as the run goes. When you come back, you read one table: what landed, what failed, what was flagged but not fixed. Nothing is ever pushed.

Invoke it by hand as `/implement-batch`; it never triggers itself.

## verify-in-browser

A code review reads the diff. This skill starts the app and watches the change behave.

It derives its cases from the spec or the diff, then walks the app once per persona. Each walker gets its own browser session and its own data, so they don't trample each other. Before anything walks, it runs the setup file's preflight, probing the database, the auth provider, whatever the app needs; a broken environment gets repaired instead of reported as a finding. Each case comes back with one of three verdicts: pass, observed-vs-expected when the app did something else, or unreached when the walk couldn't get there.

## verify-in-browser-setup

The walk needs project specifics: how to serve the app, what has to be running around it (database, auth provider, API keys), how to seed data, how each persona signs in, and which flows mean the app works. This skill reads the codebase for those facts and proves each one by running it. You get asked only the genuine decisions, in one round. It writes the setup file the walk runs on, and repairs it when it drifts. You rarely call it yourself; `verify-in-browser` reaches for it when the file is missing or a preflight probe fails.

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

`implement-batch` drives the `code-review` and `tdd` skills from `mattpocock-skills`, which ship separately. Install those too, or its review step has nothing to invoke. It finds your tickets through `docs/agents/issue-tracker.md`, the file `/setup-matt-pocock-skills` writes; without one it falls back to markdown tickets under `.scratch/`.

The browser walk needs a way to drive a browser: a browser-automation skill, a browser MCP server, or the project's own end-to-end harness run headed. The setup skill tells you if the session has none.

## License

MIT
