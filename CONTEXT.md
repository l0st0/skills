# Glossary

Terms with a settled meaning in this repo's skills. The `bump-deps` skill defines its own core terms (**manager**, **boundary**, **batch**, **tracker**) inline in its SKILL.md; this file holds the terms resolved on top of those.

## Declared surface

Every dependency a project declares directly, wherever it is declared: the root manifest, every workspace member's manifest, and any catalog the workspace tooling defines. A survey that reads only the root manifest has not covered the declared surface.

## Workspace

A member project the manager itself reports as part of the repo (e.g. entries under `apps/*`, `packages/*`). What counts as a workspace is the manager's answer, not a directory convention.

## Catalog

A single place a workspace tool lets the repo declare a dependency version once, referenced by members instead of a literal version. A catalog entry is part of the declared surface; bumping it is one edit that moves every referencing workspace.

## Logical dependency

The unit `bump-deps` surveys, classifies, bumps, and reports: one package, regardless of how many workspaces (or catalogs) declare it. Its classification is judged on the widest version jump among its declarations, and a bump moves every declaration.
