# Setup file template

The schema of the per-project setup file: `verify-in-browser-setup` writes against it, `verify-in-browser` reads by it. Edit the schema here, never in either skill's prose.

The file names what the environment cannot say for itself, and nothing more. Scripts, compose files and `.env.example` are already a source of truth — restating them here only gives them somewhere to go stale.

Its standing promise: everything the file lists as present was proven in the session that wrote it; everything missing is named, with the human action it awaits.

Sections, in this order:

## Driver

The one chosen, and one line on why, so a later run does not re-litigate it.

## Serving

The command, the base URL per app, and what an unauthenticated request does — a redirect that a walk mistakes for a failure is worth the line.

## Prerequisites

What the app needs around it to run testably — data store, auth provider, external APIs, secrets, background workers, email — each as one line naming it and its **probe**: the command that proved it in place by exercising it. The probes are the walk's **preflight** — every walk re-runs them before dispatching — so each must be cheap, read-only, and runnable verbatim from the file.

**Missing prerequisites** closes the section: each gap a human owns, with what has to be created and where, so a walk reads the gap instead of discovering it.

## Data

The seed or reset command, its guards, what the seed leaves empty, and what the destructive path does when a walk invokes it by accident: a reset that refuses without an explicit env flag is the fact that stops a walk from panicking.

## Fixtures

Where the scripts live, the command that runs one, and the teardown rules this schema forces: the tag a created row carries and the prefix its teardown deletes by, the FK constraints that fix the delete order, and every system beyond the database a teardown has to clean — an auth provider still holding users the next fixture run collides on.

## Personas

The table of verified logins with roles. Credentials go in as env var names wherever the app already reads them that way; where a literal is unavoidable, the file must be gitignored.

**Missing personas** closes the section: each persona with no working credential, with what has to be created and where.

## Agreed surface

The flows, per persona, the user agreed mean the app works — the default surface for a smoke walk. Flows, not cases: an entry point and what working looks like, no per-step expecteds.

## Reaching gated surfaces

How a token-gated or invite-only page is opened, when one exists.

## Gotchas

Only what no config confesses: the interface language a selector has to match, two controls whose labels prefix-collide, a screen that needs a hard reload.
