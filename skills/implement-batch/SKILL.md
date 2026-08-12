---
name: implement-batch
description: Implement a queue of tracker tickets one at a time — a pre-flight asks whatever the tickets leave open, a subagent builds each, you review it, a second subagent fixes what blocks. Never pushes.
disable-model-invocation: true
---

# Implement batch

One **ticket** at a time: a subagent builds it, **you** review it, a second subagent fixes what the review blocks on.

The review sits with you rather than inside the building subagent for two reasons. The author's own context is the thing a review checks, and the `code-review` skill spawns its own parallel sub-agents against a committed diff and a fixed point that only you hold.

Run straight through without pausing for confirmation. The pre-flight is the one place you stop — the user's last moment at the keyboard.

A **gate** is a condition that must hold before the run continues. A failed gate ends the whole run, reported the way step 7 says.

The arguments select tickets: a range (`09-14`), a list (`09,11,12`), `all` or empty for everything not yet done, or a path to a tickets directory optionally followed by any of those.

## 1. Build the queue

Locate the tickets: an explicit path in the arguments, else the tracker directory `AGENTS.md` or `CLAUDE.md` names, else `.scratch/*/issues/`. Ask via `AskUserQuestion` when several feature directories qualify.

Drop tickets already done — `git log --oneline` and any `Status:` line say which.

Order what remains **blockers-first**: read each ticket's blocked-by declaration — a line near the top or a heading, depending on which template wrote it — and sort topologically, file number breaking ties.

**Gate**: the working tree is clean and the branch is not the default one.

**Gate**: every blocker is already done or sits earlier in the queue. One that is neither stops the run before anything is built — name the pair.

Done when the queue is an ordered list of ticket paths and both gates hold.

## 2. Pre-flight

Read every queued ticket end to end and collect the questions a builder would otherwise answer by inventing one: an acceptance criterion naming no observable outcome, a decision the ticket defers, a requirement with two readings, a file or symbol that does not exist.

Put them to the user in as few `AskUserQuestion` passes as the four-question limit allows, then append each answer to its ticket under `## Comments`.

Answers go in the file, not just the build prompt — the ticket is also the spec source step 4 reads back, so a clarification the reviewer cannot see returns as a Spec finding.

Nothing unclear is a fine result — say so.

State the ordered queue, then start. Past a dozen or so tickets, say the queue is long enough to be worth splitting — the run log makes a second invocation pick up where this one stops — but run whatever was asked for.

Done when every collected question has an answer written into its ticket, and the user has seen the queue.

## 3. Build

Steps 3 to 6 run per ticket, in queue order.

Record `baseSha` = `git rev-parse HEAD`, then spawn **one synchronous subagent** (`run_in_background: false`, one at a time). Its prompt is the full ticket text, its path, the feature spec path if any, and:

> Implement the work described in this ticket, and only this ticket. Use `tdd` where possible, at pre-agreed seams. Run typechecking regularly, single test files regularly, and the full test suite once at the end. Leave the work as exactly one commit on the current branch; stop there — it gets reviewed after you return. Do not push.

**Gate**: `git status --porcelain` is empty, and `git log baseSha..HEAD` shows exactly one commit.

Done when that commit exists and the gate holds.

## 4. Review

Invoke the `code-review` skill, supplying what it would otherwise ask a human for: `baseSha` as the fixed point, and the ticket file path as the spec source.

Done when its Standards and Spec reports are both back.

## 5. Triage

Sort the findings by the severity language the reports already use:

- **Blocking** — hard Standards violations, where a documented repo standard is breached, plus Spec findings of type (a) missing or partial requirement and (c) implemented but wrong.
- **Carried** — smell-baseline flags, which that axis defines as judgement calls, plus Spec type (b) scope creep. These travel to the run log as-is.

Nothing blocking → step 6.

Otherwise spawn a fresh subagent — the author's context is what the review was checking — and give it the ticket text, the commit SHA, and the blocking findings alone:

> Address these review findings on the commit shown, changing only what they call for. Re-run typechecking and the full test suite. Amend the result into that commit (`git commit --amend --no-edit`). Do not push.

Then re-run step 4 against the same `baseSha`. One fix round per ticket.

**Gate**: no blocking finding survives the second review.

Done when every finding sits in exactly one of blocking or carried, and nothing blocking remains.

## 6. Close

Only once the ticket has cleared review, close its file the way the tracker says: `Status: done`, criteria ticked, what landed under `## Comments`. That line is what a re-run reads to drop finished work from the queue.

Append the ticket's row to the run log, then take the next ticket from step 3.

Done when the ticket file reads as done and its row is written.

## 7. Report

The **run log** lives beside the tickets directory — `<tickets-dir>/../run-log.md` — one row per ticket: ticket, commit SHA, blocking findings fixed, findings carried. Written as you go and readable cold, so a stopped run still tells the user what happened hours later, without the conversation.

Finish — queue emptied or gate failed — with that table, what remains in the queue, and that the branch is unpushed. On a gate failure, name where it stopped, what the gate saw, and the single thing that unblocks a re-run.

Done when the run log holds a row for every ticket that ran and the user has the closing summary.
