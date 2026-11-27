# Writing the journeys and the findings record

Every run reads both docs and every explorer's brief is cut from them, so each line costs every future run. Write them as [local-testing-guide.md](../try-every-surface/local-testing-guide.md) writes the guide: one or two sentences an entry, and none of what one walk needed, the state of the day, or history and reasons. How the app runs locally belongs to that guide, never here.

## `docs/user-journeys.md`

Exactly these three sections:

- **Personas**: each kind of person who uses the app, named in the project's own terms (its glossary, product docs or the roles in its code): who they are, what they already know, the device they most likely use, and any constraint that changes how they walk (keyboard only, low vision, a slow connection). Name the local testing guide's persona each one signs in as, or "signed out".
- **Journeys**: J1 to JN, each with its persona, **goal** (what the persona wants, in their words), **start** (where a newcomer arrives: a URL, a link from outside, an invitation), **done when** (the sign on screen that the goal is met), a **given** when the goal needs content the local data may lack (a next event with its price set, an order to track), and **status**: `proposed` until a person approves it, then `approved`, or `retired` with a one-line reason.
- **Judged against**: the path of the design source, and which of its sections hold rules a person can see broken; or "general principles" when the repo has none.

A journey earns its place when a real persona of this app has its goal, a run can finish it on the local target, and no other journey walks most of the same screens for the same persona. Keep the set to what one run can walk, about ten at most: merge two that overlap, retire one the app no longer serves. A goal and its done-when sign survive a redesign; a click path doesn't, and the explorer has to find the way itself, so steps, screens, selectors and expected results stay out. A check of one feature's behaviour is try-every-surface's work, and stays out too.

Renumber nothing: a retired journey keeps its ID, so old findings that cite it still read.

## `docs/known-findings.md`

One section, **Findings**, an entry per cause, F1 on, never renumbered:

```
- **F4** · accessibility · hurts · open — <what a person runs into, one line>. Where: <screen, condition, form factor> · J2. Seen <first run date> to <last run date>.
```

Status is `open`, or `accepted: <who decided and why, or a link to the issue or decision>`. An accepted finding is never reported again; it stays so the next run knows it was seen. An entry earns its place when an explorer reproduced it on the target, its evidence held, and it has a ground (the skill's step 5). Steps, evidence and fix leads go in the run's details file; when the repo tracks issues and someone opened one for a finding, link it in the entry.

Remove an entry once a run reports it fixed: if it comes back, it is new again. Update an entry that got worse in place, keeping its ID. Past about 50 open entries, the record is a backlog: put a Question to the user proposing which to accept or move to the issue tracker.

Done when both docs hold only these sections, and every entry passes its test above.
