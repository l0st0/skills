---
name: verify-in-browser-setup
description: Build or repair the per-project setup file a browser walk runs on. Use when that file is missing or incomplete, when a walk's preflight probe fails, when a driver or credential stopped working, or when a project gains a persona or a prerequisite.
---

# Verify in browser — setup

`verify-in-browser` walks a change through the running app; this writes the file that walk runs on — schema in [TEMPLATE.md](TEMPLATE.md) — and the walk is only as good as this file is true.

One split shapes every step: **facts** come from the environment and are proven by running them; **decisions** come from the user, asked in one round. The user is never asked for a fact the repo states, and the file never carries a fact this session did not prove.

A repair run re-enters at the step that broke — a failed probe at step 2, a dead driver or a new decision at step 3, a fixture that no longer loads at step 4, a failed credential or a new persona at step 5 — and rewrites only the sections it touched. Every step's done-criterion still binds.

## 1. Sweep the environment

Before the user is asked anything, take from the repo what it already states: the scripts that serve each app and the ports they answer on, seed and reset scripts and whatever guards them, `.env.example` and the keys a startup check demands, existing test fixtures and the personas they imply.

Then sweep for **prerequisites** — everything the app needs around it to run testably. The categories, so none is skipped silently: data store, auth provider, external APIs, secrets, background workers, email. The repo signals each one — a compose service, an SDK import, an env key a startup check demands; the category list is what turns the reading into a sweep.

List the drivers this session can actually invoke — a browser-automation skill, a browser MCP server, the project's own end-to-end harness driven headed. None, say so and stop: the walk has nothing to walk with, and the rest of the setup is wasted until the user installs one.

Done when every app, every command that puts data behind it, and every prerequisite category has been swept — each found or ruled out.

## 2. Probe the prerequisites

Each prerequisite gets a **probe**: a command that proves it in place by exercising it — connect to the data store, resolve the auth tenant, call the API with the configured key. Presence is not proof, and neither is exit 0: an env key can exist and be wrong, and a seed script whose flag the installed package-manager version no longer takes prints the script list and exits clean. Check the command did the thing.

A failing probe this session can fix — a container not started, a dependency not installed — gets fixed and re-run. One that needs a human — a tenant to provision, a secret only they can mint — becomes a Missing-prerequisites gap for step 3.

A passing probe goes into the file verbatim: it is the preflight line every walk re-runs, so keep it cheap and read-only.

Done when every prerequisite carries a probe that passed this session, or a named gap a human owns.

## 3. Ask the decisions, one round

Show what was found and proven first, so a wrong inference is caught by reading rather than asking. Then put every remaining decision into a single structured round, each question carrying the inferred answer as its recommended default: which driver, when more than one; which app a walk targets by default; the personas and the role each holds; where their credentials live; how a gated surface is reached; and the **agreed surface** — the flows per persona that, passing, mean the app works.

Where a gap needs a human — provisioning an account, an SSO tenant, a secret only they can mint — offer to generate a setup script, using a wizard skill if one is available, and write it only if the user says yes. Otherwise name what is missing and let them do it their own way.

Done when every question is asked once and answered, or recorded as a gap the user owns.

## 4. Seed, then prove a fixture

Run the seed command first: the seeded users are usually the very personas about to sign in, and a broken seed found here costs this run, not every walk.

Then prove a **fixture** — the data one walk needs and the seed does not hold: an extra org, a user in a particular state, a record positioned for the edge case. The seed is a floor, and where fixture scripts live is environment-specific, so setup settles it once instead of every walk rediscovering it. The location is often forced rather than chosen: in a workspace repo a scratch script at the root may not resolve workspace deps at all, so it sits inside the package that owns the database.

Write one throwaway fixture and its teardown, run both, and confirm the store is back where it started. What made it work is what the file records: the tag its rows carry, the order the teardown deleted in, the systems beyond the database it had to clean. Settle those here so a walk inherits them as rules instead of deriving them per case.

Done when the seed ran and did the thing, and a fixture was created and torn down with the store back where it started.

## 5. Sign in as every persona

Drive the browser to the sign-in screen and sign in as each credential, one at a time. An unverified login burns a whole walk on a login screen.

A credential that signs in becomes a row; a credential that fails, and a persona with no holder yet, goes to Missing personas instead.

Done when every row in the persona table signed in during this run.

## 6. Write it, and point at it

Write the file against [TEMPLATE.md](TEMPLATE.md) — its sections, in its order — where the project keeps its agent docs; `CLAUDE.md` or `AGENTS.md` names the place, and absent that convention, `.claude/verify-in-browser.md`. Add the pointer to `CLAUDE.md` or `AGENTS.md` so the next walk finds it.

Done when the file exists, is reachable from the pointer, carries every TEMPLATE.md section, and every command it names ran in this session.
