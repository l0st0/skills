---
name: prune-tests
description: Cut the low-signal tests from a suite so CI runs faster and flakes less, keeping every test that guards real behaviour.
disable-model-invocation: true
license: MIT
---

# Prune tests

A suite grows until much of it guards nothing: tests that no real bug turns red, or that only bugs the gate already catches do. They cost CI minutes and flakes. This pass cuts them by [rubric.md](rubric.md) and keeps every test that guards real behaviour.

Every file you change stays uncommitted for the user to review. Commit, push or open a PR only on a yes that names that action.

`<scratchpad>` is a directory outside the repo: your session's scratch directory if it has one, else a fresh temp directory. The run's lists and details live there.

## 1. Baseline

The **scope** is what the user named (a package, a directory, a pattern, or a **change** since a fixed point: a branch, tag or commit), else every test in the repo.

For a change, the diff is `git diff $(git merge-base <fixed point> HEAD)` plus untracked files, and the scope is the tests it adds or whose body it edits. The other tests in those files stay as they are. When the diff adds or edits no test, there is nothing to prune: say so and stop.

From the agent instructions, manifests and CI config, find:

- each test runner in scope, the command CI runs it with, and how it lists test IDs without running them, or else where its JSON report names them;
- the **gate**: typecheck, lint, format check, and any dead-code tool;
- every file that names tests or test files by path: CI test lists, shard or timing files, package scripts, docs.

Then, on the tree as you found it, for each package in scope:

- write the **before list** to `<scratchpad>/before.txt`: one test ID per line in the runner's own format, prefixed with the package path when there are several. A table test (`it.each`) lists as one ID, and is cut or kept whole;
- write the **scope list** to `<scratchpad>/scope.txt`: the before list's IDs that are in scope, which for a package, directory or pattern is all of them;
- run the suite as CI does, recording test count, wall time and every failing test: the **baseline failures**;
- run the gate and record what fails;
- when the repo has a coverage command, run it and keep the per-file report.

Done when every package in scope has its before list, scope list, count, wall time, baseline failures and gate result, and every file that names tests by path is noted.

## 2. Rubric

Copy [rubric.md](rubric.md) to `<scratchpad>/rubric.md` and fill its **Repo keeps**: every test the repo's docs, agent instructions or comments name as a guard (a performance budget, an upgrade guard, a patched dependency), with where it says so.

List the **sensitive paths**: the files and directories holding authentication, authorization, tenancy, money, persistence, migrations and concurrency.

Done when every documented guard you found is under Repo keeps, and the sensitive paths are listed or noted as none.

## 3. Classify

Split the test files holding the scope list's IDs into batches of about 1,500 lines, keeping each file whole. Each batch is one **classifier**: a fresh sub-agent on the cheapest model tier (Haiku, on Claude) at medium reasoning effort, since the rubric carries the judgement. A file under a sensitive path goes to two classifiers in different batches, so their verdicts are independent. Dispatch as many at once as the harness allows. Without sub-agents, classify each batch yourself, in turn, from the same brief.

Send each this brief, filled in and otherwise as written:

```
You are a test classifier. Read <scratchpad>/rubric.md. Then read each file below whole, and as much of the code each test exercises as you need to judge what its failure would catch.

Repo: <repo root>. Files:
<paths>

Test IDs, in the form your verdicts must use:
<these files' lines from scope.txt>

Judge only these IDs. The files' other tests are context.

Return one JSON line per test ID above, every one, and nothing else:
{"id": "<test ID>", "verdict": "cut|keep|deflake|rewrite", "class": "<rubric class>", "reason": "<what its failure would catch, or why nothing>", "fix": "<for deflake or rewrite: the change>"}
```

A return missing IDs, or naming IDs it wasn't given, sends the missing IDs to one fresh classifier; IDs still missing after that are keep. A test two classifiers judged is cut only when both say cut; a disagreement goes to review. Merge the verdicts into `<scratchpad>/verdicts.jsonl`, one line per ID.

Done when [scripts/check-cut.sh](scripts/check-cut.sh) `classified <scope> <ids>`, given the IDs from `verdicts.jsonl` one per line, exits 0.

## 4. Review

Classifiers run on a cheaper model, and their mistakes cluster where a test looks like a smell but guards a boundary. Expect review to overturn a quarter of what it rereads. Hand the rereads to sub-agents on your own model, each given a group of items, the rubric and this step's rules. Reread, with the code under test open:

- every verdict other than keep under a sensitive path, and every disagreement;
- every wall-clock and real-time cut: confirm it waits on real time rather than a controlled clock, and check what its other assertions guard, since the timing may be the only low-signal part;
- every cut whose title or nearby comment names a bug, issue or incident;
- every cut mirror or smoke test, and every rewrite, against the rubric's rule for rewrites;
- five cuts per remaining class, picked across packages; one wrong verdict there sends you through the whole class.

Flip each verdict you overturn and mark it **restored**, naming what the test guards. The deflakes and rewrites form the **fix list**, and every gap a verdict's reason names starts the **gap list**.

Then show the user this, and wait for their answer:

```
Cut N of T tests (P%): F files go whole, G are trimmed. Keep K, X of them on the fix list.

| Class | Cut |
|---|---|

| Package | Tests | Cut |
|---|---|---|

Restored in review: R — <what they guard, one line per group>
Fix list: <file › test — deflake or rewrite: what's wrong → the fix>, one per line
Samples: <two per class: file › test — reason>

Apply, or change something? Full list: <scratchpad>/verdicts.jsonl
```

Apply what the user changes: flip the verdicts of the tests or paths they name; when they change a class itself, edit the rubric and reclassify that class's tests. Skip the wait when the user said up front to apply without review.

Done when every verdict this step rereads is settled, and the user has approved the cut or said up front to apply without review.

## 5. Apply

Write the cut IDs to `<scratchpad>/cut.txt`, one per line. Delete each cut test by matching its describe chain and title; past a few dozen edits, script it over the language's syntax tree rather than editing by hand. A suite may be titled by a function (`describe(parseUrl, …)`), which the runner names by that function's name. Removing a file's first statement keeps the comments above it: they are the file's header, such as a test-environment pragma. Step 6 catches a miss either way.

Then remove what only the cut tests used:

- blocks and files left with no tests;
- imports, helpers, fixtures, mocks and fixture files. Delete obsolete snapshot entries by hand, since updating snapshots would also accept changed output;
- paths to deleted files in CI test lists, shard or timing files, package scripts and docs, and any package script left with no tests. A package left with no tests also loses its entry in the runner's project list and the dev dependencies only its tests used;
- production code only the cut tests used: when the gate's dead-code tool flags it, un-export it, or delete it when nothing calls it. Without such a tool, list it in the report and leave it.

Production code changes only as the last bullet says.

Done when every cut test is gone and nothing remains that only cut tests used.

## 6. Verify

- **List**: write the after list with the same command as the before list, then run `scripts/check-cut.sh applied <before> <after> <cut>`. Fix what it reports until it exits 0.
- **Gate**: fails only where the baseline failed.
- **Suite**: run it as in step 1. A failure outside the baseline failures is a kept test the cut broke, usually through a helper or setup it shared, or an order dependency the cut exposed. Fix its cause and keep the test.
- **Coverage**, when step 1 measured it: a production line covered before and not after lost its guard. Reread the cuts that exercised it, restore each one that guards behaviour a Keep class names, and rerun.
- **Planted bugs**: coverage shows a line still runs, not that a kept test turns red when it breaks. For each cut test that ran code a Keep class names, find what it asserts that no kept test asserts, and plant a bug in behaviour a Keep class names that only that assertion would catch (read only the first item, flip a comparison, drop a check, skip a write), one at a time. Run the suite with and without the cut, each in its own worktree. A bug is **guarded** when the new suite turns red on it or the gate fails on it. A bug the old suite catches and the new one leaves unguarded: restore the cut test that caught it. A bug that leaves both suites green and passes the gate joins the gap list. Revert every planted bug before going on.

Done when the list check exits 0, the gate and suite fail only where the baseline did, every coverage loss is restored or named in the report with why it can go, every planted bug the old suite caught is guarded, and every planted bug is reverted.

## 7. Report

Write the details to `<scratchpad>/prune-tests-<run id>.md`, the run id being the short commit hash and the time (`a1b2c3d-1432`): every cut grouped by file with class and reason, every restored test, the fix list, the gap list, the planted bugs and which tests turned red on each, and the after numbers per package.

Then report exactly this, which doubles as the PR body:

```
Cut N of T tests (P%): F test files deleted, G trimmed. Summed test time S → S′ (−X%).

| Package | Tests before → after | Wall time before → after |
|---|---|---|
| **total** | | |

### How the tests were picked
- Cut: <cut classes>. Keep: <keep classes>.
- <classifier passes: model, batches, which files got two passes, disagreements>
- Review restored R: <what they guard>

### Fix list
- `<file › test>` — <deflake or rewrite>: <what's wrong> → <the fix>
- <the share of the remaining test time these tests hold, when it is most of it>

### Gaps
- <behaviour no test guards, before or after the cut: what could break unnoticed>

### Follow-on cleanup
- <helpers, fixtures, exports, CI lists, scripts, docs; production code left unused, by name>

### Verification
- Test list: after = before − cut, exactly.
- Gate: <passes, or fails only as on the baseline: what>
- Suite: <passes, or each failure and that it is a baseline failure>
- Coverage: <losses accepted and why, or not measured>
- Planted bugs: <P planted, B guarded by the new suite, G by the gate, R restored; every one the old suite caught is guarded>

Details: <path>
```

Leave out empty sections. End with one line offering to commit and open a PR with this body, and, when the fix list is not empty, one offering to work through it.

## 8. Fix on request

Work through the fix list only when the user asks. Change each test as its entry says, break the behaviour it guards, watch the test go red, and revert the break. Then rerun step 6 and update the report's numbers.

Done when every changed test went red on its break and passes after the revert, and step 6's criteria hold again.
