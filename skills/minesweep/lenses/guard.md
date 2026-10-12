# Guard lens: the bar itself

An agent that hits a red check takes the cheapest road to green. The change passes the gate; this lens asks whether it passes the gate the repo had at the fixed point. Tightening the bar is silent; loosening it is always a finding.

Scan the diff, removed lines included, for five moves.

## 1. A checker got silenced

New suppressions in any ecosystem: `@ts-ignore`, `@ts-expect-error`, `as any`, `// eslint-disable*`, `// oxlint-disable*`, `// biome-ignore`, `# type: ignore`, `# noqa`, `# pylint: disable`, `//nolint`, `@SuppressWarnings`, `#[allow(...)]`, `istanbul ignore` / `c8 ignore` / `v8 ignore`, `nosemgrep`, `gitleaks:allow`, `Stryker disable`.

A suppression the repo sanctions (documented in its standards or exceptions file, or a deliberate compile-error assertion such as a `@ts-expect-error` type test) is fine. Every other one is a `blocker` when it hides a type or security check, otherwise `should-fix`, and the fix is the root cause it hides.

## 2. A test got easier

- `.skip`, `.only`, `xit`, `xdescribe`, `it.todo`, `test.fixme`, `@pytest.mark.skip`, `t.Skip()`, `@Disabled` added.
- A test file deleted, or a test case removed, while the code it covered remains.
- Assertions pulled out of a test that stayed, or weakened (`toEqual` to `toBeDefined`, exact to `toContain`, a count check dropped).
- Snapshots regenerated in the same change that altered the behaviour they pin, with no sign the new output was read.
- Expected values edited to match new output rather than the spec.

## 3. A threshold moved

Config edited down: coverage thresholds, bundle or performance budgets, lint rule severities, typechecker strictness flags, a CI step or hook removed or made non-blocking (`continue-on-error`, `|| true`, `--no-verify`), a gate script narrowed. Compare each against its state at the fixed point.

## 4. Work is unfinished

A stub that throws "not implemented", a function returning a hard-coded placeholder, an empty `catch` (or one that only logs) turning a failure into silence, a `TODO` / `FIXME` standing where the implementation should be, a feature flag left off with no ticket naming who turns it on.

## 5. An exception appeared

A new row in the repo's exceptions or allowlist file, a new entry in a lint ignore list, a dependency added to an audit allowlist. Each needs a reason and an owner the change itself states; one without is `should-fix`.
