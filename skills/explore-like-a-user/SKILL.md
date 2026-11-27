---
name: explore-like-a-user
description: "Explore a whole app as real first-time users would, on a local target, on phone, desktop and keyboard, and report what is broken, confusing, visually off, inaccessible or slow, plus what could be better. Use for a UX, visual, accessibility or speed review of an app or one of its journeys, pages or personas, including a scheduled or automated pass. To check one change against its spec or diff, use try-every-surface instead."
license: MIT
---

# Explore like a user

try-every-surface checks one change against what it should do; this skill has no expected. Explorers walk an app's **journeys** as first-time users, and report what a person would trip over, along with what would make the journey better. Explorers walk; judging what they saw is your job.

This skill runs on try-every-surface's walker and local testing guide. `<tes>` below is the directory holding try-every-surface's `SKILL.md`: `../try-every-surface/` beside this skill, the way both the skills CLI and the plugin install them. When it isn't there, look for try-every-surface among the agent's installed skills; when that fails too, stop and tell the user to install it (`npx skills add l0st0/skills -s try-every-surface`).

Read `<tes>/SKILL.md`'s opening before you start: its rules on sub-agent tiers, working in **bursts**, and leaving every file uncommitted until a yes names the action hold for this run too, explorers in place of walkers. Opening an issue counts as posting.

The run may have no one watching. Keep a **Questions** list: a decision that needs a person goes on it with your recommendation, and you carry on with the work it doesn't block. A decision the remaining work needs goes on it too: take the recommended answer when it is local and reversible, say so in the question, and carry on. Stop early only when nothing left can run without an answer, and then return the questions.

## 1. Read the record

The repo keeps this skill's memory in two docs, whose sections and contents [journeys-guide.md](journeys-guide.md) sets; read it before you write to either:

- `docs/user-journeys.md`: personas, journeys and what taste is judged against.
- `docs/known-findings.md`: every finding still open or accepted, so a run reports only what changed.

Read both when they exist, and find the **design source**: the file `docs/user-journeys.md` names, else a `DESIGN.md`, brand or style guide, or design-token file in the repo. Without one, taste rests on named general principles (step 5). Note the product's own principles too, when a doc records who the app is for and what it must do: they ground what confusing means here.

Done when you know which journeys exist and their status, every open and accepted finding, and the design source or that there is none.

## 2. Pick the journeys

Take the user's **focus** when they gave one:

- a journey: a recorded one by ID or name, else a new one written from their words
- a page or screen: every recorded journey that passes through it, plus one that arrives there cold, from wherever its persona would come in
- a persona: every journey of theirs

Without a focus, walk every approved journey. With none recorded yet, **survey** the app: its README and product docs, its route table or navigation, the roles in its code, and its landing screen. Propose 3 to 6 journeys across the personas who matter most, and record them as `proposed` the way journeys-guide.md says. Walk proposed journeys in this run anyway, and put their approval on Questions.

Done when each journey to walk has its persona, goal, start, done-when sign and any given written in `docs/user-journeys.md`, and Questions holds every journey awaiting approval.

## 3. Prepare the target

Follow `<tes>/SKILL.md`'s step 2 for the local testing guide and the target, including its stop on a target that writes to production; this run has no change under test, so the target runs the working tree as it is. Settle each open guide decision by the Questions rule, not by waiting.

A first-time user starts from what a newcomer has: signed out, or a fresh account with nothing in it, unless the persona says otherwise. Arrange each journey's starting state and its given the way the guide's Data says, since a journey that fails on missing content tests the data, not the app; give each explorer an account of its own, and sign it in before dispatch when the journey starts signed in.

When the guide's Run names a production build, explore that: a dev server's speed says little about what users get.

Done when step 2's own conditions hold, every journey's starting state and given are arranged, and every explorer that starts signed in has a saved session.

## 4. Dispatch the explorers

Pick the **run id** and `<scratchpad>` as `<tes>/SKILL.md`'s step 3 says, and dispatch, queue and resend explorers by its rules for walkers.

Each journey gets two explorers: one on a phone, one on a desktop that then walks the journey again by keyboard alone.

When there is a design source, read it once and write a **design digest**: at most 15 lines of the rules a person could see broken (type, colour, spacing, components, tone of copy) and the product principles a journey must meet, each with the heading it comes from. Send each explorer this brief, filled in and otherwise as written:

```
You are <explorer name>, a first-time <persona>: <who they are and what they know, from the record>. You walk on <phone | desktop, then keyboard only>, starting <signed out | signed in from <saved session and how to load it>>. The target is <base URL or how to reach it>, already running; leave its servers as they are. The run id is <run id>; your scratch directory is <scratchpad>/<explorer name>/.

Read <tes>/walker.md, then <the absolute path of this skill's explorer.md>, which overrides it where they differ, then <the guide files for your surfaces, its Data and its Gotchas>.

Journey <J-id>: <goal, in the persona's words>. You start at <start>. You're done when <done-when sign>.

Design digest: <the digest, or: none; judge by general principles>.
```

Done when every journey has a return in explorer.md's form from both its explorers, or is unreached for a named reason.

## 5. Judge what came back

Check each return as it lands, while the rest still walk. Read the explorer's `return.md`: its final message may come back paraphrased.

- **Evidence**: check it as `<tes>/SKILL.md`'s step 4 does, looking at every screenshot a visual finding cites. A finding still unsettled after the fresh explorer is dropped.
- **Ground**: each finding rests on something a reader can check: the design source (its heading), an accessibility criterion (WCAG 2.2, by number), a measured number against a named threshold (Core Web Vitals, or the repo's own budget), or a named usability principle (Nielsen's heuristics, say, by name). A design rule grounds a finding only where it covers that element: when the design source specifies the thing as found (a label size it allows, a placeholder it describes, a component it draws that way), the finding goes, or becomes an idea when a broader rule of the source pulls against it. Rewrite a ground that is only taste; drop a finding no ground holds.
- **Kind**: each finding has one: **broken** (does the wrong thing or nothing), **confusing** (a person can't tell what to do or what happened), **visual** (looks off against the ground), **accessibility** (shuts out a keyboard, screen reader, zoom or low-vision user), **slow** (a wait past the threshold).
- **Severity**: **blocks** (the persona can't finish the journey), **hurts** (they finish at a cost: an error, a wrong turn, a wait), or **idea** (it works, and could be better).
- **Merge**: findings sharing one cause, across explorers and form factors, become one, listing every place it shows.
- **Compare** with `docs/known-findings.md`, by cause and place, not wording: **new** (not there), **worse** (there, now more severe or in more places), **known** (there, unchanged), **accepted** (there, marked accepted), **fixed** (open there, and an explorer passed its place without seeing it). A finding whose place no explorer reached stays as it was.
- **Fix leads** and **Cleanup**: as `<tes>/SKILL.md`'s step 4 says, fix leads for each new or worse finding that blocks or hurts. For cleanup, list the driver's sessions for the run id, since explorers leave some open.

Done when every finding left has evidence that holds, a ground, a kind, a severity and a comparison, every new or worse block or hurt has a fix lead, and nothing the run started still runs or remains.

## 6. Update the record

Write what this run learned, the way journeys-guide.md says: add new findings, update worse ones, remove fixed ones, and leave known and accepted ones as they are. Tighten a journey whose goal or done-when sign proved vague. Fold environment fixes into the local testing guide as `<tes>/SKILL.md`'s step 4 says.

Done when `docs/known-findings.md` holds every new and worse finding and no fixed one, and every entry you touched in either doc earns its place.

## 7. Report

Write the details first, to `<scratchpad>/explore-like-a-user-<run id>.md`: per finding its steps a person takes to see it, evidence (screenshot paths for visual findings, quoted text for the rest), ground, fix lead and the explorers that saw it; then the path of every explorer's `return.md` and screenshot. The report stays short because the details are one question away.

Then report exactly this:

```
J journeys across P personas, on phone, desktop and keyboard: N new, W worse, X fixed since <the last run's date | the first run>. Judged against <the design source | general principles>.

### Broken
1. **<what a person runs into, in plain words>** · F4 new
   - Should: <what it should do, half a sentence> (<ground>)
   - Where: <the screen and the condition to see it> · J2 phone

### Confusing
### Visual
### Accessibility
### Slow

### Could be better
6. **<the idea, in plain words>** · F9 new
   - Why: <what a person gains> (<ground>)
   - Where: <…> · J1 desktop

### Fixed since last run
- F2 <label>

### Unreached
- J3 phone: blocked by <…>; to reach: <…>

### Questions
1. <the decision, in one sentence>? Recommend <…>; <what this run did meanwhile>.

- **Journeys:** <walked, and proposed awaiting approval>
- **Record:** <findings added, updated, removed>
- **Guide:** <each entry added, corrected or cut>
- **Stopped:** <servers, sessions>
```

- `<tes>/SKILL.md`'s step 5 rules for entries hold: empty groups and footer lines left out, plain words for someone who hasn't seen the code, and each entry ending at its Where line.
- Known and accepted findings stay out of the report.
- Each kind group holds its blocks, then its hurts, most serious first; every idea goes in Could be better. Number entries on through the groups, and tag each with its record ID and new or worse.

Done when the details file holds every finding's steps, evidence, ground and fix lead; the report holds only the template's lines, tally first and footer last, with nothing after any entry's Where line; and every finding in it is new, worse or fixed.

Answer questions and act on findings as step 5 of `<tes>/SKILL.md` says, fixing or re-walking only on the user's go-ahead.
