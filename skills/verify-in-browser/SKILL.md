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
| Nothing | the setup file's agreed surface | **offer a smoke run over it; none agreed or declined, stop and ask** |

Where the oracle is the user, present the case list you derived and ask them to confirm what each case should do. One round, then walk.

When the change is in a read path, the store underneath it is an oracle too, and a stronger one than prose: it is independent of the layer being tested. Query it directly and hand each case the exact values it should see.

Name the **axis** — the dimension along which behaviour is meant to differ — and list the screens the change touches. The scenario set is axis × screens, and every point on the axis appears in at least one case.

Smoke is a mode, not a rung: the user asks for it and the ladder is skipped — the cases are the surface per persona, the setup file's **agreed surface** unless the user names one. It has no per-case expected, so it runs against the **obviously-broken bar** instead: console errors, failed requests, 404s and 500s, blank regions where content should render, stuck loading states, unhandled errors, dead links, controls that render but do not respond. The bar is binary — an observation clears it and is a finding, or it is not one — so a smoke walk reports no Unsure.

### Bound the set

The set has a floor and a ceiling, and both hand the decision back:

- **Floor** — one path, one persona, one screen has no axis, and is cheaper to check by hand than to walk. Say so and stop here, before spending the setup.
- **Ceiling** — past roughly twenty cases, or six walkers, the run costs more than the user agreed to. Rank the cases by how likely each is to differ from the others, present the set with the cut you would make and why, and dispatch what they pick.

Done when every case carries a persona, an entry point, steps, and an expected result — or, in smoke, a persona and a surface to cover — and a set that crossed the ceiling is one the user has seen.

## 2. Load the setup, run its preflight

Read the project's verify-in-browser setup file. `CLAUDE.md` or `AGENTS.md` names where the project keeps its agent docs; absent that convention, `.claude/verify-in-browser.md`. Missing, or short of what your cases need, run `verify-in-browser-setup` and come back here with the file it writes — its TEMPLATE.md owns what a complete file contains; do not re-derive the schema here.

Then run the **preflight**: the probe command each prerequisite in the file carries. A failed probe is a setup problem, never a finding — run `verify-in-browser-setup` in repair at the step that owns it and come back; only a repair that needs a human stops the walk, naming what they must do.

Done when the file answers everything your cases need and every probe in it passed this session.

## 3. Walk them

You dispatch and aggregate; the sub-agents walk. One per axis point or persona, spawned in parallel, each handed exactly three things: the setup file verbatim, [WALKER.md](WALKER.md) verbatim, and its own cases. Nothing else — the report never enters a walker's context, so its only way to finish is to walk every case it holds. WALKER.md carries the walker's whole contract: lane discipline, fixture rules, the three verdicts, blocker handling. Do not restate it in the dispatch prompt.

Concurrent walkers share a browser and a database, so give each one its own **lane** before dispatching: a distinct driver session, and — for any walker that writes — its own records to write to. A lane is concrete. Walker A creates and edits listings prefixed `qa-a-`, walker B `qa-b-`, and neither touches the seeded row the other is reading.

Some state has no lane to split into — a singleton settings page, a global feature toggle, an account-wide preference. Hand every case that writes it to one walker, which runs them in sequence.

A session with nothing to dispatch to has one walker: you. Follow WALKER.md yourself, lane by lane, every case to a verdict before writing a word of the report — the same separation the dispatch would have bought, kept as well as a single context can keep it.

Done when every case in the set came back carrying exactly one of WALKER.md's three verdicts — pass, observed/expected, or unreached — with observations alongside.

## 4. Report

Clean run: one line. `N cases across <axis>, all pass.` Nothing more — a gate that writes paragraphs when nothing is wrong stops being read.

Otherwise split what came back, and let the user decide what happens to each:

- **In scope** — the change under test is wrong. Observed versus expected, in context, with the steps. Report it and stop; fix on the user's go-ahead.
- **Out of scope** — real, but not this change. Observed behaviour and reproduction steps only, because guessing at the cause biases whoever picks it up. Where the project has an issues directory, one file per finding, marked for triage; otherwise inline.
- **Unsure** — it looked odd and the case says nothing about it. One line each.

A finding that broke something previously working earns a committed regression test, so the next run does not rediscover it by hand. Say which one.

Done when every finding sits in exactly one of the three buckets, and every regression among them is named.
