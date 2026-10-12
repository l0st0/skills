---
name: minesweep
description: "Harden a finished change through guard, security, compatibility, performance and doubt lenses. Run after /code-review, before /shakedown."
disable-model-invocation: true
---

# Minesweep

The pass between `/code-review` and the runtime check (`/shakedown` or the project's equivalent). Code review asks whether the change follows the standards and the spec; this pass asks what the change makes possible that nobody intended.

Each **lens** is a fresh-context subagent with one reference file, and the diff decides which lenses run.

## 1. Scope the change

The fixed point is whatever the user passed, else the one `/code-review` used earlier in this conversation, else the merge-base with the default branch. On the default branch itself it is the commit before the work started: ask when that isn't obvious from the conversation.

Run [scripts/scope.sh](scripts/scope.sh) `[fixed-point]` from the repo root. Its diff runs from the merge-base to the working tree, so uncommitted work counts. Exit 2 names what is missing; resolve it before going on.

## 2. Collect the repo's rules

From the script's list and the agent instructions it points at, note the paths of: agent instructions, documented standards and sanctioned exceptions, decisions (ADRs) and glossary, and the gate. **The repo overrides**: a documented decision that accepts what a lens would flag turns the finding into nothing.

Done when each of the four kinds has its paths, or is noted as absent.

## 3. Pick the lenses

Read the diff's file list and hunks, then select:

| Lens | Runs when the diff | Reference |
|---|---|---|
| Guard | always | [lenses/guard.md](lenses/guard.md) |
| Security | crosses a trust boundary: a request handler or server function, auth, sessions, permissions, uploads, outbound fetches, file or shell operations, personal data, secrets or config, LLM calls, new dependencies | [lenses/security.md](lenses/security.md) |
| Compatibility | changes a shape something outside this deploy reads or writes: a database migration, schema or backfill; an API, webhook, event or queue payload; a route, exported API or server function signature; persisted client state; an env var, config key or flag name | [lenses/compatibility.md](lenses/compatibility.md) |
| Performance | adds or changes queries, list or collection endpoints, data loaders, caching, or heavy client dependencies | [lenses/performance.md](lenses/performance.md) |
| Doubt | carries a high-stakes claim: authorization logic, money, deletion or other irreversible writes, concurrency, a migration of live data | [lenses/doubt.md](lenses/doubt.md) |

Every lens is either selected or skipped with a one-line reason.

## 4. Dispatch the lenses in parallel

When Doubt is selected, read [lenses/doubt.md](lenses/doubt.md) and do its claim and extract steps yourself first, since its subagent sees only what you hand it. Then send every selected lens in **one message**. Each non-Doubt prompt is short, because the shared instructions live in [lenses/brief.md](lenses/brief.md):

```
<Lens> lens. Read <abs path>/lenses/brief.md, then <abs path>/lenses/<lens>.md.
Repo: <abs path>. Diff: git diff <merge-base>. Untracked: <files or none>.
Commits: <list>. Rule documents: <paths that bear on this lens>.
```

Hand each lens the agent instructions and standards, plus only the ADRs and docs whose titles bear on its concern: a lens reading thirty unrelated decisions is slower and no sharper. The step is done when every lens has returned.

## 5. Verify, then report

Findings are claims. Doubt findings go through its own reconcile step; check every other one against the code and classify it. The quoted hunk often settles it; open the file when the finding depends on code outside the quote (a caller, a guard elsewhere, a config).

- **Real**: the code does what the finding says. Keep it, at the severity [lenses/brief.md](lenses/brief.md) defines; a mitigation elsewhere lowers it only when it closes every trigger.
- **Covered**: something the subagent did not see already handles it (another layer, a repo decision, the framework). Drop it, noting what covers it.
- **Wrong**: the code does not do what the finding says. Drop it.

Then, across all lenses, a finding two lenses raise is reported once, under the lens that names the worse consequence. A finding `/code-review` already reported in this conversation is not repeated. A real finding whose cause predates the change (the same code exists at the fixed point) stays, labelled `pre-existing`, so it is not mistaken for something this change broke.

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

Ask about every debatable one in a single round of questions before touching code, so the fixing then runs without interruption. Each question names the finding's number, the options with what each costs, and your pick first, marked recommended; "leave it" is an option when skipping is defensible. With no debatable findings, skip the round and fix.

Then fix as answered, rerun the repo's gate, and paste its output. A `blocker` left unfixed, by choice or by answer, is outstanding work: name it wherever the change is tracked (the ticket, the PR).
