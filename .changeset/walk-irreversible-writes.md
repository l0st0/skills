---
"l0st0-skills": patch
---

try-every-surface: a case that runs an irreversible write on shared data (a migration, an `--apply` script run, a backfill) now walks its own copy of the database, so the other walkers' cases start from the same data instead of coming back as false passes or unreached.
