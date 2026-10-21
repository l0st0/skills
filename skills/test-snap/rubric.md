# Rubric

Judge each test by what it **guards**: the behaviour whose breaking turns it red. A test earns its place when a bug someone would notice turns it red, and nothing earlier in the gate catches that bug first.

Classify by what the assertions check, not where the file sits. A test that fits a Keep class stays even when it also fits a Cut class: a permission check written with mocks is still a permission check. A logger call mirrored inside an auth module checks no permission.

## Cut

- **type-redundant**: asserts what the type checker the gate runs already enforces: a field exists, a return has its declared type, a union has its members.
- **trivial**: a constant equals its literal, a getter returns what was set, a pass-through forwards its argument, a default has its default. A value the code computes from its input, such as an offset, a label picked by state or an attribute that tracks state, is judged by what it guards.
- **framework**: exercises the language, framework or a library rather than this code: a click fires a handler, a component renders its children, a UI library's menu or dialog handles its own keys, focus and closing, `JSON.parse` round-trips, the ORM saves a field.
- **mirror**: restates the implementation through mocks, asserting each call the code makes, so a refactor turns it red and a bug leaves it green. A telemetry call asserted only to fire, to stay silent, or to echo a log line is one.
- **smoke**: asserts only that something imports, renders or constructs without throwing, where a kept test already runs that code.
- **duplicate**: walks the same branch with the same kind of input as a kept test, so one bug turns both red. The twin runs the same unit and asserts as tightly: a component's or caller's own behaviour has its twin among its own tests, never a helper's or a sibling's, and a pinned value has its twin in a test pinning that same value. Of separate tests over one table of cases, keep one per branch and one per edge (empty, the limit and either side of it, malformed), and cut the rest.
- **wall-clock**: asserts a duration against real time.
- **real-time**: waits on real time (sleeps, real timers, polling with a timeout) to check something no Keep class names, such as a UI debounce, an animation or a cache in front of a lookup.

## Keep

- **access**: authentication, authorization, tenancy, scopes, credential expiry, including who must still be refused.
- **data**: persistence, migrations, serialization another process reads, idempotency, anything that loses data when it breaks.
- **money**: amounts, rounding, currency, billing.
- **contract**: parsing or producing an external format or protocol: files, APIs, wire messages, translation to or from another system, and the name and properties of an analytics event that dashboards or alerts key on.
- **logic**: domain rules whose failure gives a wrong result or decision: state machines, reducers and event sourcing, orchestration, job scheduling.
- **concurrency**: a deterministic race or ordering fix.
- **interface**: what a user sees or assistive technology reads that this code computes from state: a layout that visibly breaks when wrong (a sticky offset, a pinned edge), an accessible name it builds, a state attribute it sets such as `aria-sort`, where its own effect moves focus.
- **regression**: its title, a comment or its commit names a bug, issue or incident.
- **documented**: listed under Repo keeps.

A controlled clock is deterministic: fake timers, an injected `now` or a test scheduler make no flake, so judge such a test by what it guards.

## Fix list

Two verdicts keep a test that should change, and name the change:

- **deflake**: fits a Keep class but is flaky: it waits on real time, the real network, or state another test leaves behind. Name what makes it flaky and the deterministic replacement: fake timers or an injected clock, a stub server, isolated state.
- **rewrite**: fits a Cut class and no Keep class, yet it is the only test that a bug in behaviour a Keep class names turns red, such as a mirror that is the only test of a success path. Name the behaviour it should assert instead.

Before you cut a mirror or smoke test, search the rest of the test tree for another test that runs the same code. When there is none, name a bug there that a Keep class names and that turns this test red. If there is one, the verdict is rewrite. If there is none, the test guards nothing: cut it, and name the behaviour no test guards in its reason, as a **gap**.

## When unsure

Keep. A wrong keep costs seconds of CI; a wrong cut costs the bug it would have caught.

## Repo keeps

<!-- Filled in per run: each test the repo documents as a guard, and where it says so. -->
