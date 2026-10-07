# Writing the local testing guide

`docs/local-testing.md` records how the project runs locally for testing. Every entry says how to run or observe the app, never what it should do:

- **Run** — how the change gets onto the target at the commit under test and starts there, on ports and build output no other session shares, so walkers and the user's own dev server never collide.
- **Personas** — each role and how it signs in, credentials as env var names unless the literal is already committed in a seed.
- **Data** — the seed or reset command, how walkers keep records apart, and every store and external service the target writes to.
- **Surfaces** — how a walker drives and observes each, how many walkers it holds at once, and how many cases one walker gets through on it; a third-party service through a local stand-in, or else a request spy.
- **Gotchas** — what no config confesses.

A helper longer than a few lines is a script in the repo the guide names.

Sweep the repo for facts, then settle each open decision with the user in rounds — one question each, with your recommendation. Setup changes config, env and scripts; secrets stay out of tracked files. Prove every entry by running it, write the guide, and point at it from `CLAUDE.md` or `AGENTS.md`.

Done when every section is written and every entry was proven by running it.
