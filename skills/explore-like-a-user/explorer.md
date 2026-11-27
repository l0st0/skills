# Exploring a journey

You walk one journey as a first-time user, on the target already running, and return what you ran into. walker.md's Walk section holds for driver sessions, tagging, arranging and bursts. Where it speaks of cases, verdicts and returns, this file replaces it: you have a journey with a goal, no expected, and you return findings.

## Walk as a newcomer

Know only what the brief says your persona knows. Find the way by what the screen shows: its links, labels, headings and messages. App source, the route table and every repo doc but the guide files your brief names stay closed; a URL you type is one the screen showed you or the brief gave.

Head for the goal the way the persona would, and note each place you hesitated, guessed or backtracked. When you're stuck, try what a person would try (search, the menu, back, help) a few times; then record where you got stuck and why, reach the next step by the most direct way you have (a URL, the guide's Data), and carry on, so the rest of the journey still gets walked. The journey ends at its done-when sign.

Walk by form factor:

- **Phone**: a viewport about 390×844, touch emulated where the driver can. Watch what's cut off, overlaps, needs sideways scrolling, or is too small to tap (under 24×24 px).
- **Desktop**: about 1440×900, mouse. Then walk the journey again from its start by **keyboard only**: Tab, Shift+Tab, Enter, Space, Escape and the arrow keys. Watch where focus goes, whether you can see it, whether a dialog traps or loses it, and whether a skip link or landmarks let you past repeated parts.

## Watch

On every screen you pass, watch for each kind:

- **Broken**: an error, a dead link or button, a wrong or missing value, a console error or failed request (read the driver's console and network log), lost input.
- **Confusing**: a label you had to guess at, a step with no feedback, an error that doesn't say what to do, jargon your persona wouldn't know, two ways to the same thing that disagree.
- **Visual**: misalignment, clipped or overlapping text, inconsistent spacing, type or colour, a layout jump while loading. Judge against the design digest when the brief has one.
- **Accessibility**: in the accessibility tree, controls without a name, images without alt text, headings out of order, form fields without labels; on screen, text contrast and 200% zoom.
- **Slow**: time each page load and each wait for an action's result to the settle signal; on page loads read the browser's navigation and paint timings, largest contentful paint and layout shift included. Note whether the target is a dev server.

Also note what would make the journey better: a step that could go, a default that would save typing, information the persona needed sooner.

Observe by text, as walker.md says, the accessibility tree and console and network logs included. Read a style, a position or a colour only once the page has **settled**: transitions and entrance animations finished (wait out their duration), so a value caught mid-change isn't claimed. Take a screenshot for every visual finding, saved in your scratch directory with the finding's ID in its name, and look at it before you claim it: a claim about what fits on one screen names the screenshot that shows the whole screen.

## Return

Write and send it as walker.md's Return says, up to 600 words, in this form in place of its case lines: one line for the journey, then one per finding, X1 on.

```
J2 phone — finished in <N> steps | stuck at <where>: <what stopped you>
X1 — <broken | confusing | visual | accessibility | slow | idea> — <what a person sees, in plain words>; where: <screen and condition>; steps: <from the start, each naming what you acted on as the screen labels it>; evidence: <the lines that show it, quoted, or the screenshot path>; rests on: <the digest line or general principle it breaks>
```

Then a `Timings:` line (each screen you timed, load or wait in ms) and walker.md's `Fixes:` line.
