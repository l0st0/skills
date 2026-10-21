# l0st0-skills

## 1.0.0

### Major Changes

- [#22](https://github.com/l0st0/skills/pull/22) [`a2bd81c`](https://github.com/l0st0/skills/commit/a2bd81ce5008a6a73a881629437ef8814befaf43) Thanks [@l0st0](https://github.com/l0st0)! - Renamed two skills so their names say what they do: `minesweep` is now `check-side-effects`, and `shakedown` is now `try-every-surface`. Type `/check-side-effects` or `/try-every-surface` (`$check-side-effects` or `$try-every-surface` in Codex); the old commands are gone. Local-testing guides that shakedown already wrote keep working.

### Minor Changes

- [#21](https://github.com/l0st0/skills/pull/21) [`049f59a`](https://github.com/l0st0/skills/commit/049f59a1def3d1ddf2e0b96bd23e02d13490450e) Thanks [@l0st0](https://github.com/l0st0)! - prune-tests: new skill that cuts the low-signal tests from a suite so CI runs faster and flakes less. It keeps every test that guards real behaviour, checks the cut against planted bugs, lists flaky or mock-heavy tests worth fixing instead of cutting them, and reports behaviour no test guards.
