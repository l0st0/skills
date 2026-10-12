# Doubt lens: adversarial review of the riskiest claim

The author of a change shares its blind spots. A reviewer that sees only the artifact and the contract, never the author's reasoning, catches what the author argued themselves past.

## 1. Claim

Write, for yourself, the one decision in the diff whose failure costs most, in two or three lines: what holds, and why it matters if it does not. If no claim can be written that compactly, pick the hunk that touches the highest-stakes asset. The claim stays with you.

## 2. Extract

- **Artifact**: the smallest reviewable unit: the hunks and functions that implement the claim, not whole files. Past a few hundred lines, split into separate doubt runs.
- **Contract**: what the artifact must satisfy, taken from the spec or ticket and the repo's ADRs: inputs, callers, invariants, the failure behaviour expected.

Strip your reasoning from both. A reviewer handed conclusions returns agreement.

## 3. Doubt

Dispatch one fresh subagent with this prompt, followed by the artifact and contract:

> Adversarial review. Find what is wrong with this artifact. Assume the author is overconfident. Look for unstated assumptions, unhandled edge cases, hidden coupling or shared state, races and ordering assumptions, ways the contract can be violated, conventions it breaks, and failure under unexpected input. Report issues only, each with the line it rests on and a concrete input or sequence that triggers it. If after thorough examination you find none, say so.

## 4. Reconcile

The reviewer lacks context, so its output is evidence, not verdict. Re-read the artifact against each issue and classify it, first match wins:

1. **Contract misread**: the contract you wrote was unclear. Fix the contract; if the issue survives a corrected contract, re-dispatch once.
2. **Real**: report it at the severity [brief.md](brief.md) defines.
3. **Accepted trade-off**: real, but costlier to fix than to carry. Report it as `consider`, stating the trade-off.
4. **Noise**: correct under context the reviewer lacked. Drop it.

One cycle, plus at most one re-dispatch for a corrected contract. If substantive issues remain, report them; more cycles are the user's call.
