# l0st0-skills

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
