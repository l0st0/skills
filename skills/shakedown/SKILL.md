---
name: shakedown
description: Run a finished change on every surface it touches with parallel walkers, and report what it actually does.
disable-model-invocation: true
---

# Shakedown

The last gate after code review: the diff was read, now the built thing runs. You derive, prepare and report; walkers walk. Every file you change stays uncommitted: commit, push, open a PR or post only on an explicit yes to that action, which "sure", "ok" or "stop" never is.

## 1. Derive the cases

Take the first input that applies: the spec or ticket — passed in, or referenced from the branch's commits — the PR, the branch diff against the default branch, a sentence; with none, ask what to test. Name the **personas** the change touches, in the project's glossary terms, every persona when unclear.

Each **case** carries a persona, a **surface**, an entry point, steps, a **given** — the records it needs to show anything — and an **expected**, and names the criterion or diff hunk it covers; only an app-wide criterion sweeps every screen, endpoint or form factor. The surface is the one the persona uses — the app's interface for people, API or CLI for developers — dropping to stored data, messages or logs only when the criterion is about them or nothing higher shows it. With a spec, every acceptance criterion maps to cases or is **unobservable**.

The expected's claim comes from the input; each app fact under it — a route, a param, a breakpoint, when a form validates, what a form factor hides — from code outside the diff, the route table or the local testing guide, cited. Each expected is one only the change produces, or the case is a **regression**: behaviour the change must keep.

Done when every case carries all six and what it covers, every app fact cites a source, every expected is change-only or a regression, and every criterion is mapped; an app fact no source settles goes to the user before dispatch.

## 2. Load the local testing guide

`docs/local-testing.md` records how the project runs locally for testing, in five sections: **Run**, **Personas**, **Data**, **Surfaces** and **Gotchas**. Missing, write it as [local-testing-guide.md](local-testing-guide.md) says. Present, repair a fact that fails and report it, taking a repair that reverses a decision to the user first. A case reachable only by changing app code, or with a driver this machine lacks, is **unreached**, naming what it needs.

Done when the change runs on the **target** at the commit under test, every case's given exists, every surface the cases need answers, every persona is signed in, and every store and service the target writes to is local or a stand-in — production stops the run for the user.

## 3. Dispatch the walkers

Group the cases by persona — cases without one go to system walkers — and cut each group into batches no larger than the tightest Surfaces entry among them allows, five where the guide is silent, keeping one persona's cases that touch per-account state in the same batch. Each batch is one walker: a fresh sub-agent on a cheaper model than yours — `sonnet` in Claude Code, `luna` in Codex. Open the dispatch message with the cases as a table — persona, surface, given, expected, sources. Dispatch as many at once as every surface holds, and each queued walker as one frees up. Send each this brief, filled in and otherwise as written:

```
You are <walker name>, walking as <persona>, signed in by <login>.

Cases — entry point, given, steps, expected:
<cases>

Surfaces:
<the guide's entries for the surfaces these cases use>

Data and gotchas:
<the guide's Data and Gotchas>

Walk every case. Work in <scratchpad>/<walker name>/ and the driver session <walker name>, closing only those. Tag every record you create with <walker name>-<run id> and remove the tagged ones when done. A case whose given is absent is unreached. Fix what blocks the walk — a stale flag, a broken seed — and leave the behaviour under test as found. Observe by text — DOM, eval, response bodies, CLI output — and look at a screenshot only to judge how something looks.

Return exactly this, under 400 words, with <REDACTED> in place of every secret, quoting only the lines that show the behaviour:

<case> — pass | observed X, expected Y; steps: … | unreached: <blocker>
Broken: <what looked broken along the way, or none>
Fixes: <what was wrong → what repaired it, or none>
```

Done when the dispatch message opened with the table and every case has one **verdict**.

## 4. Report

Clean run: `N cases across M personas, all pass.` Otherwise: failed cases as observed versus expected with steps, then what looked broken along the way, then every environment fix. With a spec, end on a table of each criterion against its verdicts or unobservable, and offer once to post it to the PR or ticket. Fold each environment fix into the guide — a new Gotchas entry, or a correction to the entry it disproved, removing what the fix made obsolete — tighten a surface's limits where walkers collided on it or left cases unwalked, and list the files changed. Offer to diagnose each failed case, its steps serving as the reproduction; re-walk a case or fix the change only on the user's go-ahead, reporting a re-walk only from its walker's return. Last, stop every server, worktree and driver session the run started, leaving what was already running.

Done when every verdict and fix appears once, every fix is in the guide, and nothing the run started still runs.
