# l0st0-skills

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
