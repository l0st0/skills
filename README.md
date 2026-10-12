# skills

Two skills for checking a change once it's written:

- `minesweep` reads the diff for what the change makes possible that nobody intended: security holes, breaking changes for code that's still running, slow paths, weakened checks.
- `shakedown` runs the app and checks that the change works wherever it shows up: the interface, the API, the database.

Each one runs only when you type `/minesweep` or `/shakedown`. The agent never starts one on its own.

## Where they fit

They pick up after `/code-review` from [Matt Pocock's skills](https://github.com/mattpocock/skills). Code review checks the diff against the repo's standards and the spec. Minesweep looks for what the change breaks or opens up beyond that, and shakedown runs it.

```
/code-review → /minesweep → /shakedown
```

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

## Minesweep

Give it a commit or branch to compare against. Without one, it uses the point where your branch left the default branch, and it counts uncommitted work too.

A guard check always runs. It looks for a bar that got lower: a silenced linter or type error, a skipped or weakened test, a lowered threshold, unfinished work. The other lenses run only when the diff gives them something to look at:

- Security, when the change crosses a trust boundary: request handlers, auth, uploads, secrets, LLM calls, new dependencies.
- Compatibility, when it changes something outside the deploy still reads: a migration, an API payload, a route, an env var.
- Performance, when it adds queries, list endpoints, caching or heavy client dependencies.
- Doubt, when a mistake would be expensive: authorization, money, deletion, concurrency, migrating live data.

Each lens is a separate sub-agent, and they run in parallel. Minesweep then checks every finding against the code and drops the ones that are wrong, already handled elsewhere, or accepted by a decision the repo has written down.

The report starts with numbered fixes to make before merge, then things worth doing later, then what it checked and found fine. It changes no code until you pick, for example "fix 1–3". When the right fix is your call, it asks about all of those at once before editing, then reruns the repo's checks.

The lenses adapt material from Addy Osmani's [agent-skills](https://github.com/addyosmani/agent-skills). See [NOTICE.md](skills/minesweep/NOTICE.md).

## Shakedown

Give it a spec, a PR, a branch, or a one-line description. It then:

1. Writes test cases, each with an expected result, the persona it runs as, and where to check the result.
2. Starts the app locally, seeds data and signs in.
3. Sends sub-agents on a cheaper model to walk the cases in parallel. Each one takes a batch of one persona's cases.
4. Checks every failure against the evidence the sub-agent quoted and reads the code for a likely fix. It also checks whether anything else that looked broken was already broken before the change.
5. Reports each case as passed, failed or unreached.

A failure gets three short lines: what's wrong, what should happen, and where to see it. An unreached case says what blocked it and how to reach it. After the cases come other things that looked broken along the way and, if you gave it a spec, where each acceptance criterion stands. Steps, evidence and a fix lead for every entry go to a separate details file; ask about any numbered entry to see them.

Shakedown's sub-agents need a way to drive each place the change shows up: an automation skill or MCP server for the app's interface, or the project's own end-to-end test harness.

### The first run

The first time, it sets up local testing with you. It looks through the repo for what it can work out, asks you about the rest (how to seed data, what catches outgoing email), tests each answer by running it, and writes the result to `docs/local-testing.md` along with any setup files. It leaves them uncommitted, like every file it changes. It commits, pushes, opens a PR or posts a comment only when you explicitly say yes to that step.

Later runs read that guide, fix anything in it that's gone stale, and add whatever the sub-agents had to fix along the way, so the next run doesn't hit the same problem.

## License

MIT
