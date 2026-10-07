---
name: shakedown
description: Run a finished change on every surface it touches with parallel walkers, and report what it actually does.
disable-model-invocation: true
---

# Shakedown

The last gate after code review: the diff was read, now the built thing runs. You derive the cases, prepare the target, check what comes back and write the report; walkers walk.

Every file you change stays uncommitted for the user to review. Commit, push, open a PR or post only on a yes that names that action: those reach past this machine, and a general "ok" approves nothing out there.

## 1. Derive the cases

Take the first input that exists:

1. what the user passed: a spec, ticket, PR or sentence
2. a spec or ticket referenced from the branch's commits
3. the branch's PR
4. the branch diff against the default branch

With none, ask what to test. The user's words set the scope, so a spec found on the branch supplies expecteds only for what they named.

Name the **personas** the change touches, in the project's own terms: its glossary, or else the role names in its code. When it's unclear which, take every persona.

Number the **cases** C1 to CN, without gaps; the IDs carry through to the report. Each case has:

- **persona**
- **surface**: the one that persona uses, the app's interface for people and the API or CLI for developers. Drop to stored data, messages or logs only when the criterion is about them or nothing higher shows it.
- **entry point** and **steps**
- **given**: the records the case needs to show anything. A pass over missing data proves nothing.
- **expected**
- **covers**: the acceptance criterion or diff hunk it checks

With a spec, every acceptance criterion maps to cases or is **unobservable**: no surface can show it. Without one, every diff hunk that changes behaviour maps to cases. An app-wide criterion sweeps every screen, endpoint or form factor; every other gets the cases that show it.

Defects cluster at the **edges**. Where the change accepts, compares or renders a value, add cases at its edges: the boundary itself and either side of it, empty, malformed, impossible (a 30 February), and markup or other characters the surface treats specially. Where the change touches code that guards access, add a regression case for who must still be refused.

The expected's claim comes from the input. Each app fact under it (a route, a param, a breakpoint, when a form validates, what a form factor hides) comes from code outside the diff, the route table or the local testing guide, and cites that source, so a wrong inference is caught by reading. Each expected is one only the change produces, since one the default branch also produces passes either way. The exception is a **regression** case: behaviour the change must keep, marked as one.

Done when every case has all its fields, every app fact cites a source, every expected is change-only or a regression, and every criterion or behaviour-changing hunk is mapped. An app fact no source settles goes to the user before dispatch.

## 2. Prepare the target

`docs/local-testing.md` records how the project runs locally for testing, in five sections: Run, Personas, Data, Surfaces and Gotchas. If it's missing, write it as [local-testing-guide.md](local-testing-guide.md) says. If it's present, follow it, repair any fact that fails and report the repair; a repair that reverses a decision recorded there goes to the user first.

The change under test stays as written. A case reachable only by changing app code, or only with a driver this machine lacks, is **unreached**, naming what it needs.

Done when the change runs on the **target** at the commit under test, every case's given exists, every surface the cases need answers, every persona can sign in, and every store and service the target writes to is local or a stand-in. A target writing to production stops the run for the user.

## 3. Dispatch the walkers

Pick a **run id**, the short commit hash and the time (`a1b2c3d-1432`). Walkers tag their records with it, which keeps their data apart and lets cleanup find it.

Group the cases by persona; cases without one go to system walkers. Cut each group into batches no larger than the tightest Surfaces limit among them, five where the guide is silent. Keep a persona's cases that change per-account state in one batch, since two walkers on one account overwrite each other.

Each batch is one walker: a fresh sub-agent one model tier below yours, when there is one. The judgement is in the cases; walking them is legwork.

Open the dispatch message on `N cases across M personas, W walkers.`, then one line per case, `C1 · persona · surface — what it walks`. Givens, expecteds and sources stay in the briefs. Dispatch as many walkers at once as every surface holds, and start each queued walker as one finishes. Send each this brief, filled in and otherwise as written:

```
You are <walker name>, walking as <persona>, signed in by <login>.

Cases — entry point, given, steps, expected:
<cases>

Surfaces:
<the guide's entries for the surfaces these cases use>

Data and gotchas:
<the guide's Data and Gotchas>

Walk every case. Work in <scratchpad>/<walker name>/ and the driver session <walker name>, closing only those. Tag every record you create with <walker name>-<run id> and remove the tagged ones when done. A case whose given is absent is unreached. Fix what blocks the walk — a stale flag, a broken seed — and leave the behaviour under test as found. Observe by text — DOM, eval, response bodies, CLI output — and look at a screenshot only to judge how something looks. A defect in what a case checks fails it, even where its expected is silent; anything outside is a broken item.

Return under 400 words, with <REDACTED> in place of every secret. One line per case, in one of these forms:

C1 — pass: <what you saw>
C2 — fail: observed <X>, expected <Y>; steps: <…>; evidence: <the lines that show it, quoted>
C3 — unreached: <blocker>

Then:
Broken items: <case — what looked broken outside the cases, or none>
Fixes: <what was wrong → what repaired it, or none>
```

A return counts only with one line per case in those forms. Send a batch whose return lacks them to one fresh walker; when that one's lacks them too, its cases are unreached, blocked by the walker.

Done when every case has one **verdict**: pass, fail or unreached.

## 4. Check what came back

- **Fails**: confirm each one's quoted evidence shows the observed and contradicts the expected. Walkers run on a cheaper model, and a false fail costs the user a diagnosis. Evidence that doesn't hold goes to one fresh walker; still unsettled, the case is unreached, naming what stays unclear.
- **Fix leads**: for each confirmed fail, read the code the case touches and name where it breaks and the change that would fix it. It stays unconfirmed.
- **Broken items**: sort each one the verdicts don't already report into one group:
  - **Caused by this change**: the change caused it or may have, and someone needs to decide on it.
  - **Worth knowing**: the change caused it and nothing needs deciding.
  - **Already there**: shown to predate the change, on the default branch or by `git blame` on the code behind it.
- **Guide**: fold each environment fix in, as a new Gotchas entry or a correction to the entry it disproved, removing what the fix made obsolete. Tighten a surface's limits where walkers collided on it or left cases unwalked.
- **Cleanup**: stop every server, worktree and driver session the run started, servers by PID or port and sessions by their own names, leaving what was already running. Another session may be running the same app beside you.

Done when every fail's evidence holds, every fail has a fix lead, every broken item sits in a group, every environment fix is in the guide, and nothing the run started still runs.

## 5. Report

Write the details first, to `<scratchpad>/shakedown-<run id>.md`: per failure its observed, expected, steps a person takes to see it, evidence and fix lead; per pass what the walker saw; per broken item its proof and fix lead; then every walker's return. The report stays short because the details are one question away, even after the walker returns have left your context.

Then report exactly this; the Pass, Fail and Unreached groups form the **verdict list**:

```
N cases across M personas: P pass, F fail, U unreached · B possibly broken by this change. No spec.

### Pass
- C1 <label>
- C4 <label> (regression)

### Fail
1. **<what's wrong, in plain words>**
   - Should: <what it should do, half a sentence, or the numbers when they say it faster>
   - Where: <the screen and the condition to see it> · C3, C7

### Unreached
- C5 <label>: blocked by <…>; to reach: <…>

### Looked broken along the way
**Caused by this change**
2. **<what breaks, in plain words>**
   - Should: <what it should do, or the decision someone has to make>
   - Where: <the screen and the condition to see it> · C2

**Worth knowing**
3. **<what happens, in plain words>**
   - Should: <…>
   - Where: <…> · C1

**Already there**
4. **<what breaks, in plain words>**
   - Should: <…>
   - Where: <…> · C4

### Spec
- AC2 — C3 fail
- AC1, AC3–AC5 pass
- AC6 unobservable — not checked by running

### Suggested next steps
1. Diagnose 1, <its title>

- **Details:** <path> — ask about any number for steps, evidence and a fix lead.
- **Left changed:** <files this run changed> (uncommitted)
- **Guide:** <each entry added or corrected>
- **Stopped:** <servers, sessions>
```

- Leave out empty groups and footer lines, and **Spec** or `No spec.`, whichever does not apply.
- Write for someone who hasn't seen the code: what a person sees, in plain units (px, "on phones"), with file names, classes, breakpoint names and design tokens kept to the details.
- **Fail** holds an entry per cause, most serious first; cases sharing a cause share one, and a case failing for two causes sits in each. Each of its three lines is one short line: the title says what goes wrong, Should what ought to happen, and Where only the place and the condition to reach it.
- **Looked broken along the way** uses the groups from step 4, each item in the Fail shape, numbered on from the failures so every entry has its own number. B counts **Caused by this change**.
- **Suggested next steps** lists, in order: a diagnosis per failure by its number; a decision or check per item caused by this change; a re-walk per unreached case once its blocker is cleared; and, only with nothing failed, posting the report to the PR (`gh pr view` finds it) or ticket. A posted report carries the details with it, since its readers can't ask.

Done when the details file holds every failure's observed, expected, steps, evidence and fix lead; the report matches the template; every Fail and broken-item entry is three short lines cut down from a walker's return; and every case has exactly one verdict.

When the user asks about a numbered entry, answer from the details file.

After the report, re-walk a case or fix the change only on the user's go-ahead, and report a re-walk only from its walker's return.
