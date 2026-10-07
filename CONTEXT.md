# Verification

Checking a finished change by watching the running system behave, as opposed to reading its diff.

## Language

**Surface**:
A place outside the code where a change's behaviour can be observed — browser UI, HTTP API, CLI output, stored data, outbound messages, logs.
_Avoid_: terrain, environment, layer

**Target**:
The running copy of the system that surfaces are reached on.
_Avoid_: environment, terrain, stage

**Local testing guide**:
The consuming project's record of how it is set up for testing on the local target — serving, personas, data, surfaces, gotchas.
_Avoid_: project file, setup file, config

**Persona**:
A role a person plays in the system, each seeing and allowed different things.
_Avoid_: user type, actor

**Case**:
One check against a surface: a persona, an entry point, steps, a given, and an expected result.
_Avoid_: test, scenario

**Expected**:
The result a case should produce: the change's claim, taken from the input, resting on app facts taken from code outside the change, the route table or the local testing guide — never recalled. Stated with its sources so a wrong inference is caught by reading. One the default branch would also produce checks nothing about the change.

**Given**:
The records a case needs before it can show anything — a pass over missing data proves nothing, so the case is unreached.
_Avoid_: setup, fixture, precondition

**Regression**:
A case whose expected is behaviour the change must keep, rather than behaviour it adds.

**Walker**:
A sub-agent that runs a batch of one persona's cases across every surface they touch; cases with no persona go to system walkers.
_Avoid_: tester, runner, prober

**Verdict**:
The outcome of one case — exactly one of pass, observed-vs-expected, or unreached.
_Avoid_: result, status

**Verdict table**:
The table the report ends on, one row per case: what it walked, persona, what it covers, verdict.
_Avoid_: results table, summary table

**Unobservable**:
An acceptance criterion no surface can show, left to code review alone.
