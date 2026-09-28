# SubTrack — Product Backlog

**Team 15 — Bansari Patel, Max Moody**

Stories are defined in `user_stories.md`. This backlog breaks those stories into small tasks
and orders them into iterations.

**How work is ordered:**

1. **Blueprint first.** Each iteration starts with the design decision or structure that the
   rest of its tasks build on (for example the `Subscription` class before any commands, or
   deciding when to save before writing auto-save code).
2. **High priority next.** Stories in the completion criteria of `planning.md` (add, delete,
   list, save/load, monthly/yearly costs) come before robustness, usability, and stretch work.
3. **Small tasks.** Each task is about half a day or less, and ends with passing tests.
4. **Dependencies respected.** A task is only scheduled after the tasks it depends on.

## Summary

| Iteration | Dates | Goal | Stories | Points | Status |
|---|---|---|---|---|---|
| 1 | Sep 12–14 | Project skeleton and first add/list | Blueprint, US-1, US-3, US-8 (partial) | — | Done |
| 2 | Sep 15–21 | Full subscription data and planning | US-3 (partial) | — | Done |
| 3 | Sep 22–27 | Persistence, update, delete, design docs | US-4, US-5, US-7 (manual save/load), US-6 (yearly total) | 4 | Done |
| 4 | Sep 28 | Stabilize, finish core features, tests, docs | US-1, US-2, US-3, US-6, US-8, US-9, TECH-2, TECH-4, TECH-5 | 18 | Done |
| 5 | Next | Automatic persistence | US-7 | 3 | Not started |
| 6 | After 5 | Grader readiness | TECH-1, TECH-3 | 4 | Not started |
| 7 | After 6 | Usability | US-10 | 2 | Not started |

**Points:** 31 total, 22 complete, 9 remaining. Points are counted in the iteration where a
story was finished.

---

## Iteration 1: Project skeleton and first add/list (Sep 12–14): Done

**Goal:** a runnable program with the core classes in place, so every later feature has a
place to go.

| # | Task | Story | Type |
|---|---|---|---|
| 1.1 | Create repository and placeholder docs | — | Blueprint |
| 1.2 | Create `Subscription`, `SubscriptionManager`, and `StorageManager` classes (save/load stubs) | — | Blueprint |
| 1.3 | Create the CLI (`lib/subtrack.rb`) command loop, `help`, `quit`, and first RSpec test | TECH-1, US-8 | Blueprint |
| 1.4 | Add a subscription (name and cost) and list subscriptions | US-3, US-1 | Feature |
| 1.5 | Write the first user story | — | Docs |

## Iteration 2: Full subscription data and planning (Sep 15–21): Done

**Goal:** store every field a subscription needs and agree on scope before building more.

| # | Task | Story | Type |
|---|---|---|---|
| 2.1 | Add billing frequency, category, and renewal date to `Subscription` | US-3 | Blueprint |
| 2.2 | Validate fields in `Subscription` (non-empty name, positive cost, frequency) | US-3 | Feature |
| 2.3 | Prompt for all five fields in `add`, with cost and date checks in the CLI | US-3 | Feature |
| 2.4 | Planning document: app, essential vs. optional features, definition of done | — | Docs |

## Iteration 3: Persistence, update, delete, design docs (Sep 22–27): Done

**Goal:** the remaining essential operations from `planning.md`, and the design documents
that describe how the app fits together.

| # | Task | Story | Type |
|---|---|---|---|
| 3.1 | Choose JSON in `data/saved_list.json`; add `Subscription#to_json` | US-7 | Blueprint |
| 3.2 | `save` and `load` commands | US-7 | Feature |
| 3.3 | Update a subscription's cost | US-4 | Feature |
| 3.4 | Delete a subscription with confirmation | US-5 | Feature |
| 3.5 | Track the running yearly cost through add, update, and delete | US-6 | Blueprint |
| 3.6 | Design, backlog, and user story documents (written Sep 22, committed Sep 28) | — | Blueprint |

Completed: US-4 (2), US-5 (2). US-7 stays in progress: manual save/load only.

## Iteration 4: Stabilize, finish core features, tests, docs (Sep 28): Done

**Goal:** make every existing command reliable, finish the remaining core features, and
back everything with tests and accurate docs.

| # | Task | Story | Type |
|---|---|---|---|
| 4.1 | Fix crashes: zero/negative cost, save without `data/`, load without a file, Ctrl-D | US-3, US-4, US-7 | Fix |
| 4.2 | Convert renewal dates back to `Date` on load; fix default renewal date | US-7 | Fix |
| 4.3 | Aligned table output for `list` | US-1 | Feature |
| 4.4 | `help` lists every command; unknown commands point to `help` | US-8 | Feature |
| 4.5 | Unit tests for `Subscription` and `SubscriptionManager`; functional tests for the CLI | TECH-1, TECH-2 | Test |
| 4.6 | `search` by name and `filter` by category | US-2 | Feature |
| 4.7 | `summary` command with monthly and yearly totals | US-6 | Feature |
| 4.8 | Unique names (ignoring case) in add, update, delete, and load | US-9 | Feature |
| 4.9 | README: install, run, test, features, limitations | TECH-4 | Docs |
| 4.10 | Make `design.md`, `backlog.md`, and `user_stories.md` match the code | TECH-5 | Docs |

Completed: US-1 (1), US-2 (3), US-3 (3), US-6 (3), US-8 (1), US-9 (2), TECH-2 (3), TECH-4 (1),
TECH-5 (1).
All five proposal tests pass.

---

## Iteration 5: Automatic persistence: Next

**Goal:** finish US-7, the last story in the completion criteria of `planning.md`.
**Why first:** it is the only high-priority story left, and it changes how save/load
behave, so the README and tests should be finalized after it.

| # | Task | Story | Type | Depends on | Size |
|---|---|---|---|---|---|
| 5.1 | Decide when to save (after every add/update/delete, or on `quit`) and whether to keep the `save`/`load` commands; record the decision in `design.md` §4 | US-7 | Blueprint | — | S |
| 5.2 | Load the saved list on startup when the file exists; start with an empty list, without an error, when it does not | US-7 | Feature | 5.1 | S |
| 5.3 | Save automatically as decided in 5.1 | US-7 | Feature | 5.1 | S |
| 5.4 | Update `help` and the command table for any command that changes or is removed | US-7, US-8 | Feature | 5.1 | S |
| 5.5 | Add `spec/storage_manager_spec.rb` (save, load, missing file, duplicates skipped) | US-7, TECH-1 | Test | 5.2, 5.3 | M |
| 5.6 | Update functional tests: add, quit **without** `save`, restart, and the subscription is still listed; update proposal test 5 | US-7, TECH-2 | Test | 5.2, 5.3 | S |
| 5.7 | Update README ("Saving is manual" limitation), `design.md`, and story status | US-7, TECH-5 | Docs | 5.6 | S |

**Done when:** all US-7 acceptance criteria pass and the full test suite passes.

## Iteration 6: Grader readiness: After iteration 5

**Goal:** a simpler test setup for graders, and a coverage report.

| # | Task | Story | Type | Depends on | Size |
|---|---|---|---|---|---|
| 6.1 | Decide how RSpec is installed (`Gemfile` + `bundle install`, or `gem install rspec`) and update TECH-1's acceptance criteria to match | TECH-1 | Blueprint | — | S |
| 6.2 | Apply the decision from 6.1 (add a `Gemfile` or keep the manual install) | TECH-1 | Setup | 6.1 | S |
| 6.3 | Add a coverage report (SimpleCov) to `coverage/`, including code run by the functional tests; add `coverage/` to `.gitignore` | TECH-3 | Setup | 6.2 | M |
| 6.4 | README: coverage instructions, final test count, install steps from 6.2 | TECH-1, TECH-3 | Docs | 6.3, iteration 5 | S |
| 6.5 | Check the README from a fresh clone on a second machine (both team members) | TECH-1, TECH-3 | Test | 6.4 | S |

**Done when:** TECH-1 and TECH-3 acceptance criteria pass.

## Iteration 7: Usability: After iteration 6

**Goal:** one typo no longer cancels a whole command.

| # | Task | Story | Type | Depends on | Size |
|---|---|---|---|---|---|
| 7.1 | Design a shared prompt helper that repeats a prompt until the value is valid, with a way to cancel; update the "fail fast" decision in `design.md` §5 | US-10 | Blueprint | — | S |
| 7.2 | Use the helper for every `add` field | US-10 | Feature | 7.1 | S |
| 7.3 | Use the helper for the new cost in `update` | US-10 | Feature | 7.1 | S |
| 7.4 | Handle Ctrl-D inside a prompt in the helper (currently crashes) | US-10 | Fix | 7.1 | S |
| 7.5 | Functional tests: invalid value then valid value, cancel, Ctrl-D mid-prompt | US-10 | Test | 7.2–7.4 | S |
| 7.6 | Update README, `design.md`, and story status | US-10, TECH-5 | Docs | 7.5 | S |

**Done when:** all US-10 acceptance criteria pass.

## Icebox (not scheduled)

Ideas with no story yet. Write a story and schedule it only if there is time after
iteration 7.

- Let `update` change the frequency, category, renewal date, and name, not only the cost.
- Handle a damaged save file (invalid JSON or invalid values) without crashing.
- Let save/load work from any folder, not only one named `CSCE-606-Project-1`.
- Stretch features from `planning.md`: upcoming renewals, sorting, spending by category.

---

## Test plan

The five scenarios from the project proposal, one per core feature. All five are automated in
`spec/subtrack_functional_spec.rb` and pass.

1. **Add**: add Netflix at $24.99/month, then attempt a negative price. Expect Netflix listed
   and the negative price rejected.
2. **Search**: add Netflix and Spotify, search Netflix, then search a name that does not
   exist. Expect the details returned, then "Subscription not found."
3. **Update / delete**: change Netflix from $19.99 to $24.99, then delete it. Expect the new
   price shown, then Netflix no longer found.
4. **Summary**: Netflix $20/month, Spotify $10/month, Amazon Prime $120/year. Expect $40 per
   month and $480 per year.
5. **Persistence**: add Netflix, save, close the application, restart it, and load. Expect
   Netflix loaded from storage. (After iteration 5: no `save`/`load` needed.)
