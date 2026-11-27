# l0st0-skills

## 1.8.0

### Minor Changes

- [#48](https://github.com/l0st0/skills/pull/48) [`093a4d5`](https://github.com/l0st0/skills/commit/093a4d5b67a70bc54009faa922b4128712b103ea) Thanks [@l0st0](https://github.com/l0st0)! - explore-like-a-user: a new skill that explores a whole app as first-time users would, on phone, desktop and keyboard, and reports what is broken, confusing, visually off, inaccessible or slow, plus what could be better. You can type it, and the model or an automation can start it too. It keeps the app's journeys and known findings in the repo's docs, so each run reports only what is new, worse or fixed. try-every-surface: its walker instructions can now be overridden by a file the sub-agent is pointed at, which explore-like-a-user uses; try-every-surface's own runs work as before.

## 1.7.0

### Minor Changes

- [#44](https://github.com/l0st0/skills/pull/44) [`169296f`](https://github.com/l0st0/skills/commit/169296fb8a4b398f34f913e5225da5ec3bac0b8b) Thanks [@l0st0](https://github.com/l0st0)! - try-every-surface: runs take less time. The orchestrator works in bursts, starts builds and servers while it derives cases, dispatches each batch as soon as its own target is ready, and sends a re-check walker as soon as evidence fails. Walkers start signed in, read their fixed rules from a bundled `walker.md` instead of a long brief, walk each case in bursts that end on a condition wait, get time-based givens arranged instead of waited out, and save their returns to disk. The local testing guide now records how to save a session, move a record's time, and wait for each surface to settle.

## 1.6.0

### Minor Changes

- [#45](https://github.com/l0st0/skills/pull/45) [`9e89922`](https://github.com/l0st0/skills/commit/9e899220bcf99178d91127223ecf4ff6a6e9f3c8) Thanks [@l0st0](https://github.com/l0st0)! - check-side-effects: other skills and the model can now call it, so a landing step can run the risk pass itself instead of asking you to type it.

## 1.5.0

### Minor Changes

- [#42](https://github.com/l0st0/skills/pull/42) [`f9b7f6f`](https://github.com/l0st0/skills/commit/f9b7f6f40ccec17405f4c1209ee73d3da61c1b83) Thanks [@l0st0](https://github.com/l0st0)! - try-every-surface: walks cost less, finish sooner and cover new screens fully. Each case's starting state is arranged through the guide's Data (a seed, a query, a command) instead of clicked through, each walker gets at most four cases and an account of its own, and walkers read only what a verdict needs and wait on results instead of fixed sleeps. Every legwork sub-agent, walker or repo search, runs one model tier down, and the lead keeps working while it runs. Batches on a surface that takes one walker at a time start first and carry only the cases that need it. A screen the change adds gets a case that checks everything it shows, its progress and ways out included, and reopens it once the flow has moved on. The local testing guide's Data section now says how to arrange each persona's common states.

## 1.4.1

### Patch Changes

- [#38](https://github.com/l0st0/skills/pull/38) [`3adb4a3`](https://github.com/l0st0/skills/commit/3adb4a38c0817149aed73d861e26bbb122fabe6b) Thanks [@l0st0](https://github.com/l0st0)! - try-every-surface: drop look cases. They judged a rough prototype's unfinished spacing and copy as the planned look, so they failed builds that were fine.

- [#41](https://github.com/l0st0/skills/pull/41) [`f2ac368`](https://github.com/l0st0/skills/commit/f2ac36884b098aed3347f37c1fcf10766e7bd7b0) Thanks [@l0st0](https://github.com/l0st0)! - try-every-surface: the local testing guide's Data section now records how to copy the database for a walker of its own, and the run makes that copy the way the guide says instead of assuming Postgres.

- [#40](https://github.com/l0st0/skills/pull/40) [`25f295c`](https://github.com/l0st0/skills/commit/25f295c658de28a406d7b752f47142b5b2ef5a8e) Thanks [@l0st0](https://github.com/l0st0)! - try-every-surface: a case that runs an irreversible write on shared data (a migration, an `--apply` script run, a backfill) now walks its own copy of the database, so the other walkers' cases start from the same data instead of coming back as false passes or unreached.

## 1.4.0

### Minor Changes

- [#36](https://github.com/l0st0/skills/pull/36) [`d7dbe88`](https://github.com/l0st0/skills/commit/d7dbe88a2b89c5a64347173a44341b90ffb18f80) Thanks [@l0st0](https://github.com/l0st0)! - try-every-surface: a change that adds or restyles something a person sees gets a look case per form factor, judged from screenshots against the planned look (the prototype, comp or mock the input points at, else the documented design system, else the nearest sibling in the app).

## 1.3.0

### Minor Changes

- [#35](https://github.com/l0st0/skills/pull/35) [`482c6de`](https://github.com/l0st0/skills/commit/482c6dec0e8a942cc5cb636a874202cc1ef3d612) Thanks [@l0st0](https://github.com/l0st0)! - try-every-surface: a pass quotes its evidence and gets checked like a fail, and walkers reach each case through the persona's own surface. Edge cases now cover repeated, stale, concurrent and interrupted actions; behaviour the diff adds beyond the spec is reported; a change with nothing to run stops in one line.

### Patch Changes

- [#33](https://github.com/l0st0/skills/pull/33) [`3684656`](https://github.com/l0st0/skills/commit/3684656c98f6ab47faf6768eed293e2beee985d5) Thanks [@l0st0](https://github.com/l0st0)! - try-every-surface: every case's expected names something the surface shows (a reply, a header, a value), so a silent fallback can't pass as "no errors".

## 1.2.0

### Minor Changes

- [#30](https://github.com/l0st0/skills/pull/30) [`3209a3a`](https://github.com/l0st0/skills/commit/3209a3a80c96ec7da8e0ea22e1404c4a32fee710) Thanks [@l0st0](https://github.com/l0st0)! - prune-tests: cuts tests that only assert removed or moved code is gone (a new **obsolete** class), counts assertions on private state, call order and mocks of the unit under test as **mirror**, and puts a test whose expected value repeats the code's own formula on the fix list with the literal to pin.

## 1.1.0

### Minor Changes

- [#27](https://github.com/l0st0/skills/pull/27) [`2fbf56f`](https://github.com/l0st0/skills/commit/2fbf56ffece05baedf8348b07dc06e5d729409c1) Thanks [@l0st0](https://github.com/l0st0)! - prune-tests: a scope of five tests or fewer is classified in one pass by the running agent instead of dispatching classifier sub-agents, so pruning a small change before a PR costs far fewer tokens.

## 1.0.1

### Patch Changes

- [#24](https://github.com/l0st0/skills/pull/24) [`2d40dce`](https://github.com/l0st0/skills/commit/2d40dce4202a4423b5ddb22c50007e24b3e07932) Thanks [@l0st0](https://github.com/l0st0)! - prune-tests: name a branch, tag or commit to prune only the tests the change since then adds or edits, such as before opening a PR.

## 1.0.0

### Major Changes

- [#22](https://github.com/l0st0/skills/pull/22) [`a2bd81c`](https://github.com/l0st0/skills/commit/a2bd81ce5008a6a73a881629437ef8814befaf43) Thanks [@l0st0](https://github.com/l0st0)! - Renamed two skills so their names say what they do: `minesweep` is now `check-side-effects`, and `shakedown` is now `try-every-surface`. Type `/check-side-effects` or `/try-every-surface` (`$check-side-effects` or `$try-every-surface` in Codex); the old commands are gone. Local-testing guides that shakedown already wrote keep working.

### Minor Changes

- [#21](https://github.com/l0st0/skills/pull/21) [`049f59a`](https://github.com/l0st0/skills/commit/049f59a1def3d1ddf2e0b96bd23e02d13490450e) Thanks [@l0st0](https://github.com/l0st0)! - prune-tests: new skill that cuts the low-signal tests from a suite so CI runs faster and flakes less. It keeps every test that guards real behaviour, checks the cut against planted bugs, lists flaky or mock-heavy tests worth fixing instead of cutting them, and reports behaviour no test guards.
