---
name: verify-in-browser
description: Walk a change through the running app in a browser, across every persona, and report what it actually does. Use when the user asks to verify, QA, or smoke a change in the running app, when a code review has passed and the change has not been seen running, or when a spec's behaviour has to be seen rather than read.
---

# Verify in browser

The third axis of review. A code review reads the diff against standards and spec; this walks the built thing through a browser and reports what it does.

The walk needs an **oracle** — an independent statement of what correct looks like. Reading the implementation to decide that makes the walk agree with itself, and it will confirm the bug along with everything else. Every step below exists to protect the oracle.

## 1. Derive the cases

Take the first rung that applies, and stop there:

| Source | Gives you | Oracle |
| --- | --- | --- |
| Spec or tickets for this change | cases and expected | the spec |
| An axis the user provided | cases | ask the user, per case |
| Branch diff, then PR diff | cases | ask the user, one round, per case |
| Nothing | — | **stop and ask what to test** |

Where the oracle is the user, present the case list you derived and ask them to confirm what each case should do. One round, then walk.

When the change is in a read path, the store underneath it is an oracle too, and a stronger one than prose: it is independent of the layer being tested. Query it directly and hand each case the exact values it should see.

Name the **axis** — the dimension along which behaviour is meant to differ — and list the screens the change touches. The scenario set is axis × screens, and every point on the axis appears in at least one case.

Smoke is a mode, not a rung: the user asks for it and names the surface, and the ladder is skipped — the cases are the named surface, per persona. It has no per-case expected, so it runs against the **obviously-broken bar** instead: console errors, failed requests, 404s and 500s, blank regions where content should render, stuck loading states, unhandled errors, dead links, controls that render but do not respond.

### Bound the set

The set has a floor and a ceiling, and both hand the decision back:

- **Floor** — one path, one persona, one screen has no axis, and is cheaper to check by hand than to walk. Say so and stop here, before spending the setup.
- **Ceiling** — past roughly twenty cases, or six walkers, the run costs more than the user agreed to. Rank the cases by how likely each is to differ from the others, present the set with the cut you would make and why, and dispatch what they pick.

Done when every case carries a persona, an entry point, steps, and an expected result — or, in smoke, a persona and a surface to cover — and a set that crossed the ceiling is one the user has seen.

## 2. Load the setup

Read the project's verify-in-browser setup file. `CLAUDE.md` or `AGENTS.md` names where the project keeps its agent docs; absent that convention, `.claude/verify-in-browser.md`.

Present and complete — a driver available in this session, a serve command and base URL, and one login per persona your cases need — go to step 3.

Missing, or short of what your cases need, run `verify-in-browser-setup` and come back here with the file it writes.

## 3. Walk them

You dispatch and aggregate; the sub-agents walk. One per axis point or persona, spawned in parallel, each given the setup file verbatim, the driver to use, and its own cases — and nothing about the report, so a walker's only way to finish is to walk every case it holds.

Concurrent walkers share a browser and a database, so give each one its own **lane** before dispatching: a distinct driver session, and — for any walker that writes — its own records to write to. A lane is concrete. Walker A creates and edits listings prefixed `qa-a-`, walker B `qa-b-`, and neither touches the seeded row the other is reading. Walkers that collide return plausible wrong answers rather than errors, which is the one failure this whole skill exists to catch.

Some state has no lane to split into — a singleton settings page, a global feature toggle, an account-wide preference. Hand every case that writes it to one walker, which runs them in sequence.

A session with nothing to dispatch to has one walker: you. Take the lanes in sequence, and walk every case to a verdict before writing a word of the report — the same separation the dispatch would have bought, kept as well as a single context can keep it.

The browser transcript stays in the sub-agent. Per case it returns one of:

- **pass**
- **observed X, expected Y**, with the steps that produced it
- **unreached**, with what blocked it

A case the walk could not reach is unreached, never pass.

When something blocks the walk, the test is whether the fix unblocks it — a broken seed command, a stale dev-server flag, a fixture that no longer loads. Fix those and carry on. The behaviour under test stays untouched: fixing it inside the walk destroys the oracle one step later than reading the implementation would. A blocker in the change itself, and any blocker that resists an obvious fix, makes that case unreached and travels back as the blocker it is — diagnosis is the next job, not this one.

Anything that looks broken along the way is worth noting even when no case asks about it — carry it back as an observation.

Done when every case in the set came back as exactly one of pass, observed/expected, or unreached.

## 4. Report

Clean run: one line. `N cases across <axis>, all pass.` Nothing more — a gate that writes paragraphs when nothing is wrong stops being read.

Otherwise split what came back, and let the user decide what happens to each:

- **In scope** — the change under test is wrong. Observed versus expected, in context, with the steps. Report it and stop; fix on the user's go-ahead.
- **Out of scope** — real, but not this change. Observed behaviour and reproduction steps only: no file paths, no diagnosis, no proposed fix, because guessing at the cause biases whoever picks it up. Where the project has an issues directory, one file per finding, marked for triage; otherwise inline.
- **Unsure** — it looked odd and the case says nothing about it. One line each. Smoke runs have no Unsure: an observation either clears the obviously-broken bar and is out of scope, or it is not a finding.

A finding that broke something previously working earns a committed regression test, so the next run does not rediscover it by hand. Say which one.
