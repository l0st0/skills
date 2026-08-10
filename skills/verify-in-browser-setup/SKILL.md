---
name: verify-in-browser-setup
description: Build or repair the per-project setup file a browser walk runs on. Use when that file is missing or incomplete, when a walk's driver or credentials stopped working, or when a project gains a persona.
---

# Verify in browser — setup

`verify-in-browser` walks a change through the running app; this writes the file that walk runs on, and the walk is only as good as this file is true.

The file names what the environment cannot say for itself, and nothing more. Scripts, compose files and `.env.example` are already a source of truth — restating them here only gives them somewhere to go stale.

A repair run re-enters at the step that broke — a dead driver at step 2, a new gap at step 3, a fixture that no longer loads at step 4, a failed credential or a new persona at step 5 — and rewrites only the sections it touched. Every step's done-criterion still binds.

## 1. Read the environment

Before asking the user anything, take from the repo what it already states: the scripts that serve each app and the ports they answer on, seed and reset scripts and whatever guards them, `.env.example` and the keys a startup check demands, existing test fixtures and the personas they imply.

The repo states the commands; this session proves them. Every command headed for the file runs before it is written, and exit 0 is not proof: a seed script whose flag the installed package-manager version no longer takes prints the script list and exits clean, and every walk that reads that file believes it seeded. Check the command did the thing.

Done when you can name every app the project serves and every command that puts data behind it.

## 2. Choose the driver

The **driver** is how this session drives a browser: a browser-automation skill, a browser MCP server, or the project's own end-to-end harness driven headed.

List what this session actually has. More than one, ask the user which to use. None, say so and stop — the walk has nothing to walk with, and the rest of the setup is wasted until they install one.

Done when one driver is named, and it is one this session can invoke right now.

## 3. Ask for the rest, one round

Put every remaining gap into a single round of questions. The gaps are always some of: which app a walk targets by default, which personas exist and what role each holds, where their credentials live, and how a private or token-gated surface is reached.

Where a step needs a human — provisioning an account, an SSO tenant, a secret only they can mint — offer to generate a setup script, using a wizard skill if one is available, and write it only if the user says yes. Otherwise name what is missing and let them do it their own way.

Done when every question is asked once and answered, or recorded as a gap the user owns.

## 4. Seed, then prove a fixture

Run the seed command first: the seeded users are usually the very personas about to sign in, and a broken seed found here costs this run, not every walk.

Then prove a **fixture** — the data one walk needs and the seed does not hold: an extra org, a user in a particular state, a record positioned for the edge case. The seed is a floor, and where fixture scripts live is environment-specific, so setup settles it once instead of every walk rediscovering it. The location is often forced rather than chosen: in a workspace repo a scratch script at the root may not resolve workspace deps at all, so it sits inside the package that owns the database.

Write one throwaway fixture and its teardown, run both, and confirm the store is back where it started. What made it work is what the file records: the tag its rows carry, the order the teardown deleted in, the systems beyond the database it had to clean. Settle those here so a walk inherits them as rules instead of deriving them per case.

Done when the seed ran and did the thing, and a fixture was created and torn down with the store back where it started.

## 5. Sign in as every persona

Drive the browser to the sign-in screen and sign in as each credential, one at a time. An unverified login burns a whole walk on a login screen.

A credential that signs in becomes a row. A credential that fails, and a persona with no holder yet, stays out of the table and goes into a **Missing personas** section naming what has to be created and where — so the next walk reads the gap instead of discovering it.

Credentials go in as env var names wherever the app already reads them that way. Where a literal is unavoidable, confirm the file is gitignored before writing it.

Done when every row in the persona table signed in during this run.

## 6. Write it, and point at it

Write the file where the project keeps its agent docs; absent that convention, `.claude/verify-in-browser.md`. Add the pointer to `CLAUDE.md` or `AGENTS.md` so the next walk finds it.

Sections, in this order:

- **Driver** — the one chosen, and one line on why, so a later run does not re-litigate it.
- **Serving** — the command, the base URL per app, and what an unauthenticated request does (a redirect that a walk mistakes for a failure is worth the line).
- **Data** — the seed or reset command, its guards, what the seed leaves empty, and what the destructive path does when a walk invokes it by accident: a reset that refuses without an explicit env flag is the fact that stops a walk from panicking.
- **Fixtures** — where the scripts live, the command that runs one, and the teardown rules this schema forces: the tag a created row carries and the prefix its teardown deletes by, the FK constraints that fix the delete order, and every system beyond the database a teardown has to clean — an auth provider still holding users the next fixture run collides on.
- **Personas** — the table of verified logins with roles, then **Missing personas**.
- **Reaching gated surfaces** — how a token-gated or invite-only page is opened, when one exists.
- **Gotchas** — only what no config confesses: the interface language a selector has to match, two controls whose labels prefix-collide, a screen that needs a hard reload.

Done when the file exists, is reachable from the pointer, and every command it names ran in this session.
