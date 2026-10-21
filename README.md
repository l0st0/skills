# skills

Three skills. Two check a change after you've written it:

- `minesweep` reads the diff for side effects nobody intended: security holes, changes that break code still running, slow paths, weakened checks.
- `shakedown` runs the app and checks that the change works everywhere it shows up: the interface, the API, the database.

The third, `prune-tests`, cuts the tests that cost CI time and catch nothing.

None of them starts on its own. Type `/minesweep`, `/shakedown` or `/prune-tests` to run one (`$minesweep`, `$shakedown` or `$prune-tests` in Codex).

Run minesweep and shakedown after code review. Code review checks the diff against the repo's standards and the spec. Minesweep looks for what the change breaks or opens up beyond that, and shakedown runs it. Each works without the other.

## Install

Any agent, via the [skills CLI](https://skills.sh):

```sh
npx skills add l0st0/skills -g
```

Claude Code, as a plugin:

```
/plugin marketplace add l0st0/skills
/plugin install l0st0-skills@l0st0
```

## Minesweep

Give it a commit or branch to compare against. Without one, it compares against the point where your branch left the default branch, uncommitted work included.

It always checks whether the change lowered a bar: a silenced linter or type error, a skipped or weakened test, a lowered threshold, unfinished work. Other checks run only when the diff calls for them:

- Security, when the change crosses a trust boundary: request handlers, auth, uploads, secrets, LLM calls, new dependencies.
- Compatibility, when it changes something that code outside the deploy still reads: a migration, an API payload, a route, an env var.
- Performance, when it adds queries, list endpoints, caching or heavy client dependencies.
- Doubt, when a mistake would be expensive: authorization, money, deletion, concurrency, migrating live data.

Each check runs as its own sub-agent, all in parallel. Minesweep then checks every finding against the code and drops the ones that are wrong, already handled elsewhere, or accepted by a decision written down in the repo.

The report has three parts:

1. Numbered fixes to make before merge.
2. Things to do later.
3. What it checked and found fine.

It changes no code until you pick fixes, for example "fix 1–3". If any of them needs a decision from you, it asks all those questions at once before editing. Then it reruns the repo's own checks.

The checks adapt material from Addy Osmani's [agent-skills](https://github.com/addyosmani/agent-skills). See [NOTICE.md](skills/minesweep/NOTICE.md).

## Shakedown

Give it a spec, a PR, a branch or a one-line description. It then:

1. Writes test cases. Each one has an expected result, a persona to run as, and a place to check the result.
2. Starts the app locally, seeds data and signs in.
3. Hands the cases to sub-agents on a cheaper model. They run in parallel, each taking a batch of one persona's cases.
4. Checks every failure against the evidence the sub-agent quoted, and reads the code for a likely fix. It also checks whether anything else that looked broken was already broken before the change.
5. Reports each case as passed, failed or unreached.

The sub-agents need a way to use each place the change shows up: an automation skill or MCP server for the app's interface, or the project's own end-to-end test harness.

### The report

Each failure gets three short lines: what's wrong, what should happen, and where to see it. Each unreached case says what blocked it and how to reach it.

After the cases come other things that looked broken along the way. If there's a spec, the report also shows where each acceptance criterion stands.

Steps, evidence and a lead on the fix for every entry go to a separate details file. Ask about any numbered entry to see them.

### The first run

The first time, shakedown sets up local testing with you:

1. It works out what it can from the repo.
2. It asks you about the rest, such as how to seed data or what catches outgoing email.
3. It tests each answer by running it.
4. It writes the result to `docs/local-testing.md`, plus any setup files.

Every file it changes stays uncommitted. It commits, pushes, opens a PR or posts a comment only when you explicitly say yes to that step.

Later runs read the guide and fix anything in it that's gone stale. When a sub-agent had to fix something that would block a run on any change, shakedown adds that fix to the guide so the next run doesn't hit the same problem.

## Prune tests

Give it a package or a directory, or nothing for the whole repo. It then:

1. Records the suite as it stands: every test's ID, the time it takes, and what already fails.
2. Hands the test files to sub-agents on a cheaper model, which mark each test against one rubric. Files that hold auth, money, data or concurrency code get two independent passes, and a test there goes only when both agree.
3. Rereads the risky verdicts itself: every cut in that code, every cut for timing (a test on a fake clock isn't flaky), and every test that names a bug.
4. Shows you the tally and waits. Say up front that you don't need to review it, and it goes on.
5. Deletes the cut tests and whatever only they used: helpers, fixtures, and paths in CI and docs.
6. Checks the result: the test list shrank by exactly the cut list, the repo's checks fail only where they failed before, and bugs it plants in the code the cut tests ran are still caught.

It cuts tests of what the types already guarantee, constants, the framework, mocks called in the order the code calls them, smoke tests, duplicate table rows, and tests that wait on real time or assert a duration. It keeps tests of auth and permissions, data, money, external formats, domain logic, concurrency fixes, past bugs, what users see or screen readers announce, and any test the repo documents as a guard.

A flaky test that guards something real stays and goes on a fix list with its deterministic replacement. So does a mock-heavy test that is the only one to catch a bug on its path. It works through the list when you ask. Behaviour that no test catches, before or after the cut, is reported as a gap.

The report doubles as the PR body, and nothing is committed until you say so.

The approach follows a [T3 Code PR](https://github.com/pingdotgg/t3code/pull/22557) that cut 11,000 of its 26,000 tests.

## License

MIT
