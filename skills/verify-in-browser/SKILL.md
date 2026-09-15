---
name: verify-in-browser
description: Walk a change through the running app in a browser, one walker per persona, and report what it actually does.
disable-model-invocation: true
---

# Verify in browser

A code review reads the diff; this walks the built thing and reports what it does. You derive, prepare and report; sub-agents walk.

## 1. Derive the cases

Take the first input that applies: the spec or ticket, the PR, the branch diff against the default branch, anything the user hands over. Nothing at all, stop and ask what to test. From it name the **personas** the change touches — every persona when unclear — and the screens it reaches. Each case carries a persona, an entry point, steps, and an **expected** result inferred from the input; the report states the inference so a wrong one is caught by reading.

Done when every case carries all four.

## 2. Load the project file

`docs/verify-in-browser.md` holds what the repo cannot say for itself, in four sections: **Serve** — the command and base URL; **Personas** — each role and how it signs in, credentials as env var names unless the literal is already committed in a seed script; **Data** — the seed or reset command and how one walker keeps its records apart from another's; **Gotchas** — what no config confesses. Missing, sweep the repo for serve scripts, seed scripts and test credentials, prove each by running it, ask the user in one round only for what could not be found, write the file, and point at it from `CLAUDE.md` or `AGENTS.md` where one exists. A fact that fails on a later run is repaired in the file the same way, and the report says so.

Done when the app is served and seeded, and every persona the cases need signed in this session.

## 3. Dispatch the walkers

One sub-agent per persona, in parallel, handed the base URL, its login, the file's Data and Gotchas sections, and its cases with expecteds. The dispatch prompt carries the walker's rules and nothing of the report: create only records prefixed with your persona and delete them when done; fix what blocks the walk — a stale flag, a broken seed — and leave the behaviour under test as found; return each case as exactly one of **pass**, **observed X, expected Y** with the steps, or **unreached** with the blocker, plus anything that looked broken along the way.

Done when every case came back with one verdict.

## 4. Report

Clean run: one line, `N cases across M personas, all pass.` Otherwise: failed cases as observed versus expected with steps, then what looked broken along the way, then every environment fix this run made. Fix the change only on the user's go-ahead.

Done when every verdict and every fix appears once.
