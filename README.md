# skills

One skill for coding agents: `shakedown`. When a change is done, it runs the app and checks that the change works, instead of only reading the diff. It looks wherever the change shows up: the app's interface, the API, the database.

Use it last, after code review. It only runs when you type `/shakedown`. The agent never starts one on its own.

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

The sub-agents need a way to drive each place the change shows up: an automation skill or MCP server for the app's interface, or the project's own end-to-end test harness.

## How it works

Give it a spec, a PR, a branch, or a one-line description. It then:

1. Writes test cases, each with an expected result, the persona it runs as, and where the result is checked.
2. Gets the change running locally, seeds data, and signs in.
3. Sends sub-agents on a cheaper model to walk the cases in parallel. Each one takes a batch of one persona's cases.
4. Reports every case as pass, failed (what it saw next to what it expected), or unreached (what blocked it). If you gave it a spec, the report ends with a table of each acceptance criterion and its result.

## The first run

The first time, it sets up local testing with you. It looks through the repo for what it can work out, asks you about the rest (how to seed data, what catches outgoing email), tests each answer by running it, and commits the result as `docs/local-testing.md` along with any setup files.

Later runs read that guide, fix anything in it that's gone stale, and add whatever the sub-agents had to fix along the way, so the next run doesn't hit the same problem.

## License

MIT
