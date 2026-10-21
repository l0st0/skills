---
name: check-side-effects
description: "Sweep a finished change for what it makes possible that nobody intended: security holes, breaking changes, slow paths, weakened checks."
disable-model-invocation: true
license: MIT
---

# Check side effects

Code review asks whether the change follows the standards and the spec; this pass asks what the change makes possible that nobody intended.

## 1. Scope the change

Run [scripts/scope.sh](scripts/scope.sh) with the fixed point the user named, else the one a code review earlier in this conversation used, else no argument. On exit 2 or a `== note` line, resolve what it reports before going on, asking the user when the conversation doesn't settle it.

## 2. Collect the repo's rules

From the script's list and the agent instructions it points at, note the paths of: agent instructions, documented standards and sanctioned exceptions, decisions (ADRs) and glossary, and the gate.

Done when each of the four kinds has its paths, or is noted as absent.

## 3. Pick the lenses

Read the diff's file list and hunks, then select:

| Lens | Runs when the diff |
|---|---|
| Guard | always |
| Security | crosses a trust boundary: a request handler, auth, sessions, permissions, uploads, outbound fetches, file or shell operations, personal data, secrets or config, LLM calls, new dependencies |
| Compatibility | changes a shape something outside this deploy reads or writes: a database migration, schema or backfill; an API, webhook, event or queue payload; a route, exported API or RPC signature; persisted client state; an env var, config key or flag name |
| Performance | adds or changes queries, list or collection endpoints, data loaders, caching, or heavy client dependencies |
| Doubt | carries a high-stakes claim: authorization logic, money, deletion or other irreversible writes, concurrency, a migration of live data |

Every lens is either selected or skipped with a one-line reason.

## 4. Dispatch the lenses in parallel

When Doubt is selected, read [lenses/doubt.md](lenses/doubt.md) and do its claim and extract steps yourself first, since its subagent sees only what you hand it. Then dispatch every selected lens at once, each in its own fresh subagent. Every lens but Doubt gets this prompt, filled in and otherwise as written:

```
<Lens> lens. Read <skill dir>/lenses/brief.md, then <skill dir>/lenses/<lens>.md.
Repo: <repo root>. Diff: git diff <merge-base>. Untracked: <files or none>.
Commits: <list>. Rule documents: <agent instructions, standards, and the ADRs and docs whose titles bear on this lens>.
```

Done when every lens has answered in the shape its prompt asks for.

## 5. Verify, then report

Findings are claims. Doubt findings go through its own reconcile step; check every other one against the code and classify it. The quoted hunk often settles it; open the file when the finding depends on code outside the quote (a caller, a guard elsewhere, a config).

- **Real**: the code does what the finding says. Keep it at the severity [lenses/brief.md](lenses/brief.md) defines, even when a mitigation closes only some of its triggers.
- **Covered**: something the subagent did not see already handles it (another layer, a repo decision, the framework). Drop it, noting what covers it.
- **Wrong**: the code does not do what the finding says. Drop it.

Then a finding two lenses raise is reported once, with the worse consequence. A finding a code review already reported in this conversation is not repeated. A real finding whose cause predates the change (the same code exists at the merge-base) stays, labelled `pre-existing`, so it is not mistaken for something this change broke.

The step is done when every finding is classified. Then write the report once. The lens shape (quoted hunks, `Rule:`) is for verifying; the report is for a person deciding what to fix, so group by what to do, not by lens, and say each finding in plain words:

```
## Fix before merge          ← blocker and should-fix, grouped under ### <what it puts at risk>
1. **<What goes wrong, for whom, in plain words.>** <One sentence of how, if needed.>
   *Fix:* <the change>. `file:line`
## Worth doing later         ← consider, one terse bullet per item, grouped by area
## Checked and fine          ← what was dropped or verified, one line each
```

Number every fix-before-merge item, one per finding, so the user can answer "fix 1–4". Mark `(pre-existing)` inline. End with the skipped lenses in one line and which numbers you would fix first.

## 6. Fix on request

The pass reports; it changes code only when the user asks. "Fix 1–4" settles *which* findings, not always *how*. Before editing, sort the chosen findings:

- **Clear-cut**: one fix a reasonable reviewer would pick, staying inside the change. Just do it; asking here is noise.
- **Debatable**: the fix is the user's call, when any of these holds:
  - two sound fixes trade off differently (reject vs clamp, migrate vs dual-read);
  - it changes behaviour a user or caller sees;
  - it reaches beyond the change (a `pre-existing` cause, a shared module, a contract);
  - it overrides or would need a documented decision;
  - you doubt the finding deserves a fix at all.

Ask about every debatable one in a single round of questions before touching code, so the fixing then runs without interruption. Each question names the finding's number, the options with what each costs, and your pick first, marked recommended; "leave it" is an option when skipping is defensible.

Then fix as answered, rerun the repo's gate, and paste its output. End by listing every `blocker` left unfixed, by choice or by answer, as outstanding.
