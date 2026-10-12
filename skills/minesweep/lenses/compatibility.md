# Compatibility lens: old and new running at once

A deploy is never instant. During every rollout, and for as long as anything outlives it, old and new code run side by side: two app versions against one database, a browser tab loaded before the deploy calling the new server, a mobile app months behind, a job queued by the old code and run by the new, another service still sending last month's payload. Each change must leave every version that can still be running working. Data is the one thing a rollback does not restore, so stored shapes get the most care.

## Find the contracts the diff touches

List every shape the change alters that something outside this deploy reads or writes:

- **Stored data**: database tables and columns, documents, cache entries, files and object-store keys.
- **Wire contracts**: public or internal API request and response shapes, status codes, error formats, GraphQL or RPC schemas, webhook and event payloads, messages on a queue.
- **Addresses**: routes and URLs others link to or bookmark, server function names a stale client bundle still calls, exported package APIs.
- **Persisted client state**: local storage, cookies, IndexedDB, service-worker caches, URL search params in shared links.
- **Operations**: environment variables, config keys, feature-flag names, CLI flags, cron and job names.

For each, name who still holds the old shape and for how long. A shape nothing outside the deploy reads is not a contract; skip it.

## Expand, migrate, contract

A contract never changes in place. The safe shape is additive phases, each its own deploy:

1. **Expand**: add the new column, field, route, key or variable beside the old one; readers accept both.
2. **Migrate**: write both shapes, backfill or translate what is stored, switch readers and callers to the new shape.
3. **Contract**: once nothing still running reads the old shape, remove it in a later, separate deploy.

Additive first; destructive last and alone. A removal states how anyone knows nothing still uses the old shape.

## What to flag

- **A breaking change shipped with the code that needs it**: a dropped or renamed column, table, field, route or variable; a type change; a field made required; an enum value removed; a tightened constraint or validation over data that already exists. `blocker` when a version that can still be running uses the old shape.
- **Readers that cannot read what exists**: new code that crashes on old rows, payloads, queued jobs or stored client state; old code (an open tab, an older app, a consumer) that crashes on a new enum value or field. `blocker` when the data already exists in production or the old reader is still running: the crash needs no further trigger. Parse with a fallback or a versioned shape.
- **Deploy ordering**: does the migration run before or after the new code goes live in this repo's pipeline, and does each order leave a working system? Same for a client and its server, a producer and its consumer.
- **Locks on large tables**: a single `UPDATE` over every row, an index built without the non-blocking option (Postgres `CREATE INDEX CONCURRENTLY`), a column rewrite on a big table. Backfills run in batches, off the request path.
- **Rollback story**: a down migration exists and runs, or the change states why it is forward-only and how a bad deploy is recovered. Data written by the new version must still be readable by the old one after a rollback.
- **Generated artifacts**: the migration and its snapshot or metadata, and any generated client or schema file, were produced by the repo's generator command, not edited by hand, unless the repo documents otherwise.
- **Data correctness**: a backfill that guesses (defaults that misstate existing rows), a cascade delete reaching further than the change intends.
- **Seeds, fixtures and examples** (`.env.example`, sample configs) updated to the new shape, so a fresh environment still boots.
