---
name: shakedown
description: Run a finished change on every surface it touches with parallel walkers, and report what it actually does.
disable-model-invocation: true
---

# Shakedown

The last gate after code review: the diff was read, now the built thing runs. You derive, prepare and report; walkers walk.

## 1. Derive the cases

Take the first input that applies: the spec or ticket, the PR, the branch diff against the default branch, a sentence. Nothing, ask what to test. Name the **personas** the change touches — every persona when unclear. Each **case** carries a persona, a **surface**, an entry point, steps, and an **expected** result inferred from the input; the report states the inference. A case checks what the change touched, sweeping every page, endpoint or viewport only for a sitewide criterion. The surface is the one the persona uses — browser for people, API or CLI for developers — dropping to stored data, outbound messages or logs only when the criterion is about them or nothing higher shows it. With a spec, every acceptance criterion maps to cases or is **unobservable**.

Done when every case carries all five and every criterion is mapped.

## 2. Load the local testing guide

`docs/local-testing.md` records how the project runs locally for testing: **Serve** — the start command; **Personas** — each role and how it signs in, credentials as env var names unless the literal is already committed in a seed; **Data** — the seed or reset command and how walkers keep records apart; **Surfaces** — how to observe each, a third-party service through a local stand-in or else a request spy; **Gotchas** — what no config confesses.

Missing: sweep the repo for facts, then settle each open decision with the user in rounds — one question per decision, each with your recommendation. Prove every entry by running it, write the guide, point at it from `CLAUDE.md` or `AGENTS.md` where one exists, and commit it with its setup files in one `chore` commit. Setup changes config, env, scripts and compose files; secrets stay uncommitted. A case reachable only by changing app code is **unreached**, naming the change. Present: a fact that fails is repaired and reported; a repair that reverses a decision goes to the user first.

Done when the app is served and seeded, every surface the cases need answers, and every persona is signed in.

## 3. Dispatch the walkers

Split the cases into walkers of one persona and at most five cases each — cases without a persona go to system walkers — and dispatch every walker at once as a fresh sub-agent, with `model: "sonnet"` in Claude Code. Each gets its name, its cases with expecteds, its login, and the guide's Surfaces, Data and Gotchas. The prompt carries the walker's rules and nothing of the report: prefix every record and session you create with your name and delete them when done; fix what blocks the walk — a stale flag, a broken seed — and leave the behaviour under test as found; return each case as exactly one of **pass**, **observed X, expected Y** with the steps, or **unreached** with the blocker, plus anything that looked broken along the way.

Done when every case has one verdict.

## 4. Report

Clean run: `N cases across M personas, all pass.` Otherwise: failed cases as observed versus expected with steps, then what looked broken along the way, then every environment fix. With a spec, end on a table of each criterion against its verdicts or unobservable, and offer once to post it to the PR or ticket. Re-walk a case or fix the change only on the user's go-ahead.

Done when every verdict and fix appears once.
