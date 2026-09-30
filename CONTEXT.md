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
One check against a surface: a persona, an entry point, steps, and an expected result.
_Avoid_: test, scenario

**Expected**:
The result a case should produce, inferred from the input and stated so a wrong inference is caught by reading.

**Walker**:
A sub-agent that runs a batch of one persona's cases across every surface they touch; cases with no persona go to system walkers.
_Avoid_: tester, runner, prober

**Verdict**:
The outcome of one case — exactly one of pass, observed-vs-expected, or unreached.
_Avoid_: result, status

**Unobservable**:
An acceptance criterion no surface can show, left to code review alone.
