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
4. Checks every failure against the evidence the sub-agent quoted, reads the code for a likely fix, and checks whether anything else that looked broken was already broken before the change.
5. Reports every case under its result: pass, failed (what's wrong, what it should be and where to see it, one short line each), or unreached (what blocked it and how to reach it). Steps, evidence and a fix lead for each failure go to a details file; ask about any numbered entry to get them. Then come what looked broken along the way, in the same three lines, a line per acceptance criterion if you gave it a spec, and suggested next steps that name every failure, so the end of the terminal shows them.

## The first run

The first time, it sets up local testing with you. It looks through the repo for what it can work out, asks you about the rest (how to seed data, what catches outgoing email), tests each answer by running it, and writes the result to `docs/local-testing.md` along with any setup files. It leaves them uncommitted, like every file it changes. It commits, pushes, opens a PR or posts a comment only when you explicitly say yes to that step.

Later runs read that guide, fix anything in it that's gone stale, and add whatever the sub-agents had to fix along the way, so the next run doesn't hit the same problem.

## License

MIT
