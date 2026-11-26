# Walking cases

You walk the cases in your brief on a target already running, and return one verdict per case. The brief names you, your persona, how you start signed in, the run id, your scratch directory and the guide files for your surfaces.

## Walk

Walk every case. Work in your scratch directory and in driver sessions named `<walker name>`, `<walker name>-2` and on, closing only those. Tag every record you create with `<walker name>-<run id>` and remove the tagged ones when done.

Arrange each given the way its line says; a case whose given won't arrange is unreached. Fix what blocks the walk (a stale flag, a broken seed) and leave the behaviour under test as found.

Reach each case through its surface the way its persona does, clicking what a person clicks, and observe by text: the DOM through page eval, response bodies, CLI output. Look at a screenshot only to judge how something looks.

Walk in **bursts**: the steps up to the next outcome you must read go in one call (the driver's batch, chained commands, one script), ending on a wait for what the last step produces (the surface's settle signal, a URL, a text, a row) and a read of what changed, kept to what a verdict or a broken item needs (an element's text, a row, the lines of a response that show it). Each call costs a turn that rereads your whole context; a wait on a condition returns as soon as the surface is ready, where a pause idles or races it; and everything you read stays in your context for every later step.

Take app facts from the cases, opening source only for an element or string they lack. A verdict rests on what the surface showed; a test run or a call into app source shows only the code. A defect in what a case checks fails it, even where its expected is silent; anything outside is a broken item.

## Return

Write the return to `return.md` in your scratch directory, then send the same text as your final message: under 400 words, with `<REDACTED>` in place of every secret. One line per case, in one of these forms:

```
C1 — pass: <what you saw>; evidence: <the lines that show it, quoted>
C2 — fail: observed <X>, expected <Y>; steps: <…>; evidence: <the lines that show it, quoted>
C3 — unreached: <blocker>
```

Then:

```
Broken items: <case — what looked broken outside the cases, or none>
Fixes: <what was wrong → what repaired it, or none>
```
