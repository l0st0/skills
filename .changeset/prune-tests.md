---
"l0st0-skills": minor
---

prune-tests: new skill that cuts the low-signal tests from a suite so CI runs faster and flakes less. It keeps every test that guards real behaviour, checks the cut against planted bugs, lists flaky or mock-heavy tests worth fixing instead of cutting them, and reports behaviour no test guards.
