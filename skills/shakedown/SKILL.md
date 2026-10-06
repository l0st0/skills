---
name: shakedown
description: Run a finished change on every surface it touches with parallel walkers, and report what it actually does.
disable-model-invocation: true
---

# Shakedown

The last gate after code review: the diff was read, now the built thing runs. You derive, prepare and report; walkers walk.

## 1. Derive the cases

Take the first input that applies: the spec or ticket — passed in, or referenced from the branch's commit messages — the PR, the branch diff against the default branch, a sentence. Nothing, ask what to test. Name the **personas** the change touches, in the project's glossary terms where one exists — every persona when unclear. Each **case** carries a persona, a **surface**, an entry point, steps, and an **expected** result inferred from the input; the report states the inference. Each expected is one only the change produces, or the case is marked **regression**: behaviour the change must keep. A case checks what the change touched, sweeping every screen, endpoint or form factor only for an app-wide criterion. The surface is the one the persona uses — the app's own interface for people, API or CLI for developers — dropping to stored data, outbound messages or logs only when the criterion is about them or nothing higher shows it. With a spec, every acceptance criterion maps to cases or is **unobservable**.

Done when every case carries all five, every expected is change-only or marked regression, every criterion is mapped, and the cases are printed as a table — persona, surface, expected — without waiting on it, so the user can interrupt a wrong inference.

## 2. Load the local testing guide

`docs/local-testing.md` records how the project runs locally for testing: **Run** — how the change gets onto the **target** and starts there; **Personas** — each role and how it signs in, credentials as env var names unless the literal is already committed in a seed; **Data** — the seed or reset command and how walkers keep records apart; **Surfaces** — how a walker drives and observes each, how many walkers it holds at once, and how many cases one walker gets through on it, a third-party service through a local stand-in or else a request spy; **Gotchas** — what no config confesses. Every entry says how to run or observe the app, never what it should do; a helper longer than a few lines is a committed script the guide names.

Missing: sweep the repo for facts, then settle each open decision with the user in rounds — one question per decision, each with your recommendation. Prove every entry by running it, write the guide, point at it from `CLAUDE.md` or `AGENTS.md` where one exists, and commit it with its setup files in one `chore` commit. Setup changes config, env and scripts; secrets stay uncommitted. A case reachable only by changing app code, or only with a driver this machine lacks, is **unreached**, naming what it needs. Present: a fact that fails is repaired and reported; a repair that reverses a decision goes to the user first.

Done when the change runs on the target, seeded, every surface the cases need answers, and every persona is signed in.

## 3. Dispatch the walkers

Group the cases by persona — cases without one go to system walkers — and cut each group into batches no larger than the tightest Surfaces entry among them allows, five where the guide is silent. Each batch is one walker: a fresh sub-agent on a cheaper model than yours — `sonnet` in Claude Code, `luna` in Codex. Dispatch as many at once as every surface holds, and each queued walker as one frees up. Send each this brief, filled in and otherwise as written:

```
You are <walker name>, walking as <persona>, signed in by <login>.

Cases — entry point, steps, expected:
<cases>

Surfaces:
<the guide's entries for the surfaces these cases use>

Data and gotchas:
<the guide's Data and Gotchas>

Walk every case. Keep what you create apart as Data says, and remove it when done. Fix what blocks the walk — a stale flag, a broken seed — and leave the behaviour under test as found.

Return each case as exactly one of: pass; observed X, expected Y, with the steps; unreached, with the blocker. Then anything that looked broken along the way, and each fix as what was wrong and what repaired it. Write <REDACTED> in place of every secret, quote only the lines that show the behaviour, and stay under 300 words.
```

Done when every case has one **verdict**.

## 4. Report

Clean run: `N cases across M personas, all pass.` Otherwise: failed cases as observed versus expected with steps, then what looked broken along the way, then every environment fix. With a spec, end on a table of each criterion against its verdicts or unobservable, and offer once to post it to the PR or ticket. Fold each environment fix into the guide — a new Gotchas entry, or a correction to the entry it disproved, removing what the fix made obsolete — and tighten a surface's limits where walkers collided on it or left cases unwalked; commit it as `chore`. Offer to diagnose each failed case, its steps serving as the reproduction; re-walk a case or fix the change only on the user's go-ahead.

Done when every verdict and fix appears once and every fix is in the guide.
