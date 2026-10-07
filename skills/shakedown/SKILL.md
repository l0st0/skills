---
name: shakedown
description: Run a finished change on every surface it touches with parallel walkers, and report what it actually does.
disable-model-invocation: true
---

# Shakedown

The last gate after code review: the diff was read, now the built thing runs. You derive, prepare and report; walkers walk. Every file you change stays uncommitted: commit, push, open a PR or post only on an explicit yes to that action, which "sure", "ok" or "stop" never is.

## 1. Derive the cases

Take the first input that applies: the spec or ticket — passed in, or referenced from the branch's commits — the PR, the branch diff against the default branch, a sentence; with none, ask what to test. Name the **personas** the change touches, in the project's glossary terms, every persona when unclear.

Each **case** is numbered C1 to CN, without gaps, and carries a persona, a **surface**, an entry point, steps, a **given** — the records it needs to show anything — and an **expected**, and names the criterion or diff hunk it covers; only an app-wide criterion sweeps every screen, endpoint or form factor. The surface is the one the persona uses — the app's interface for people, API or CLI for developers — dropping to stored data, messages or logs only when the criterion is about them or nothing higher shows it. With a spec, every acceptance criterion maps to cases or is **unobservable**; without one, every diff hunk that changes behaviour maps to cases the same way.

The expected's claim comes from the input; each app fact under it — a route, a param, a breakpoint, when a form validates, what a form factor hides — from code outside the diff, the route table or the local testing guide, cited. Each expected is one only the change produces, or the case is a **regression**: behaviour the change must keep.

Done when every case carries all six and what it covers, every app fact cites a source, every expected is change-only or a regression, and every criterion or behaviour-changing hunk is mapped; an app fact no source settles goes to the user before dispatch.

## 2. Load the local testing guide

`docs/local-testing.md` records how the project runs locally for testing, in five sections: **Run**, **Personas**, **Data**, **Surfaces** and **Gotchas**. Missing, write it as [local-testing-guide.md](local-testing-guide.md) says. Present, repair a fact that fails and report it, taking a repair that reverses a decision to the user first. A case reachable only by changing app code, or with a driver this machine lacks, is **unreached**, naming what it needs.

Done when the change runs on the **target** at the commit under test, every case's given exists, every surface the cases need answers, every persona is signed in, and every store and service the target writes to is local or a stand-in — production stops the run for the user.

## 3. Dispatch the walkers

Group the cases by persona — cases without one go to system walkers — and cut each group into batches no larger than the tightest Surfaces entry among them allows, five where the guide is silent, keeping one persona's cases that touch per-account state in the same batch. Each batch is one walker: a fresh sub-agent on a cheaper model than yours — `sonnet` in Claude Code, `luna` in Codex. Open the dispatch message on `N cases across M personas, W walkers.`, then one line per case — `C1 · persona · surface — what it walks` — under the IDs the **verdict list** reuses; givens, expecteds and sources stay in the walkers' briefs. Dispatch as many at once as every surface holds, and each queued walker as one frees up. Send each this brief, filled in and otherwise as written:

```
You are <walker name>, walking as <persona>, signed in by <login>.

Cases — entry point, given, steps, expected:
<cases>

Surfaces:
<the guide's entries for the surfaces these cases use>

Data and gotchas:
<the guide's Data and Gotchas>

Walk every case. Work in <scratchpad>/<walker name>/ and the driver session <walker name>, closing only those. Tag every record you create with <walker name>-<run id> and remove the tagged ones when done. A case whose given is absent is unreached. Fix what blocks the walk — a stale flag, a broken seed — and leave the behaviour under test as found. Observe by text — DOM, eval, response bodies, CLI output — and look at a screenshot only to judge how something looks. A defect in what a case checks fails it, even where its expected is silent; anything outside is a broken item.

Return exactly this, under 400 words, with <REDACTED> in place of every secret, quoting only the lines that show the behaviour:

<case> — pass: <what you saw> | observed X, expected Y; steps: … | unreached: <blocker>
Broken items: <case — what looked broken outside the cases, or none>
Fixes: <what was wrong → what repaired it, or none>
```

Done when the dispatch message opened with the case list and every case has one **verdict**.

## 4. Report

Fold each environment fix into the guide — a new Gotchas entry, or a correction to the entry it disproved, removing what the fix made obsolete — and tighten a surface's limits where walkers collided on it or left cases unwalked. Stop every server, worktree and driver session the run started, leaving what was already running. Then report exactly this, the Pass, Fail and Unreached groups forming the **verdict list**:

```
N cases across M personas: P pass, F fail, U unreached · B possibly broken by this change. No spec.

### Pass
- C1 <label>: <what the walker saw, one sentence>
- C4 <label> (regression): <what the walker saw, one sentence>

### Fail
1. **C3, C7 <label, naming where it breaks>**
   - **Observed:** <the one fact that fails the case>
   - **Expected:** <one short line>
   - **Steps:** <what a person does in the app to see it, with any condition it needs>
   - **Fix lead (unconfirmed):** <where> — <change>

### Unreached
- C5 <label>: blocked by <…>; to reach: <…>

### Looked broken along the way
**Caused by this change**
- **<what breaks, where>** · C2
  - <proof the title can't hold, one short line>

**Worth knowing**
- **<what happens, where>** · C1

**Already there**
- **<what breaks, where>** · C4

### Spec
- AC2 — C3 fail
- AC1, AC3–AC5 pass
- AC6 unobservable — left to code review

### Suggested next steps
1. Diagnose C3, C7 <label> — observed <X>, expected <Y>

- **Left changed:** <files this run changed> (uncommitted)
- **Guide:** <each entry added or corrected>
- **Stopped:** <servers, sessions>
```

- Leave out empty groups and footer lines, and **Spec** or `No spec.`, whichever does not apply.
- Describe what a person sees; file names, classes and properties appear only in fix leads.
- **Fail** holds an entry per cause, most serious first; cases sharing a cause share one, and a case failing for two causes sits in each.
- **Looked broken along the way** holds the broken items no failure already reports, in the report's voice, each with a proof line only when its title can't hold the proof: **Caused by this change** — the change caused it or may have, B counting them; **Worth knowing** — harmless side effects of the change itself, environment fixes going to the guide and the footer; **Already there** — present before the change.
- **Suggested next steps** lists, in order: a diagnosis per failure, naming its cases and what went wrong, a decision or check per broken item caused by this change, a re-walk per unreached case once its reach lead is met, and — only with nothing failed — posting the report to the PR (`gh pr view` finds it) or ticket.

Re-walk a case or fix the change only on the user's go-ahead, reporting a re-walk only from its walker's return.

Done when the report matches the template, every case has exactly one verdict, every environment fix is in the guide, and nothing the run started still runs.
