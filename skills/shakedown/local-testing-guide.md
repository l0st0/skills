# Writing the local testing guide

`docs/local-testing.md` records how the project runs locally for testing. Every run reads it and every walker's brief carries its Data and Gotchas, so each line costs every future run: it holds only what the next walker, on any change, needs and can't read off the repo. Every entry says how to run or observe the app, never what it should do, in these five sections and no others:

- **Run** — how the change gets onto the target at the commit under test and starts there, on ports, devices or simulators, build output and app data no other session shares, so walkers and the user's own dev server never collide.
- **Personas** — each role and how it signs in, credentials as env var names unless the literal is already committed in a seed.
- **Data** — the seed or reset command, how walkers keep records apart, and every store and external service the target writes to.
- **Surfaces** — how a walker drives and observes each, how many walkers it holds at once, and how many cases one walker gets through on it; a third-party service through a local stand-in, or else a request spy.
- **Gotchas** — what no config confesses, each opening on the surface it bites (`**Browser**:`) unless it bites every walker, since a walker's brief carries only its own surfaces' gotchas.

An entry earns its place when leaving it out would cost a walker on an unrelated change a wrong verdict, a collision, a write that leaves the machine, or more than a few minutes. These fail that test and stay out:

- **What the app does**: a screen's or an endpoint's behaviour, a message's wording, the fields a form or a request demands, the route or endpoint list. The code and the surface say it, and the next feature changes it.
- **What one walk needed**: a fixture, a workaround, a selector or a request body for one feature. It goes in that run's details file.
- **The state of the day**: an outage, a failing staging endpoint, anything dated "as of". It goes in the report as a blocker; only a dependency it revealed, which the guide was missing, goes in.
- **The tool, not the project**: shell quoting, a driver or simulator flag, a command the OS lacks. It holds on every project, so it belongs to the tool's own docs.
- **History and reasons**: when an entry was proven, which PR moved it, why it is so. Keep a reason only when it changes what the walker does.

Each entry is one or two sentences: the command or the fact. A helper longer than a few lines is a script in the repo the guide names.

Sweep the repo for facts, then settle each open decision with the user in rounds — one question each, with your recommendation. Setup changes config, env and scripts; secrets stay out of tracked files. Prove every entry by running it, write the guide, and point at it from `CLAUDE.md` or `AGENTS.md`.

Done when every section is written, and every entry was proven by running it and passes the test above.
