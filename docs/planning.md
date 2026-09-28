# SubTrack — Planning Discussion

**Team 15 — Bansari Patel, Max Moody**

This document records the team's planning decisions.

## App

SubTrack, a subscription tracking and management app.

SubTrack is a command-line Ruby application for people with several recurring subscriptions
(streaming, software, gym memberships) billed on different cycles. It keeps every
subscription in one place and shows what they cost together, per month and per year.

## Essential features

These are the features the project cannot be "done" without. Each maps to a user story.

| Feature | Story |
|---|---|
| Adding subscriptions (name, cost, billing frequency, category, renewal date) | US-3 |
| Listing subscriptions | US-1 |
| Deleting subscriptions | US-5 |
| Storing the subscription list persistently between sessions | US-7 |
| Showing monthly and yearly subscription costs | US-6 |

When the stories were written, two more features were treated as core because the essential
features are hard to use without them: **updating** a subscription's cost (US-4), and a
**help** command listing every command (US-8).

## Optional features

| Feature | Story / status |
|---|---|
| Filter subscriptions by category / search for an individual named subscription | US-2, delivered in iteration 4. Search is also one of the five proposal test scenarios. |
| Displaying subscriptions renewing within a given period | Future work (`design.md` §8) |
| Sorting subscriptions by name, cost, category, or next billing date | Future work |
| Displaying cost for a given category | Future work |

**Robustness work** was added after the core features were in place, when a review of the
code found gaps that made them unreliable:

- Unique subscription names, so totals are never double-counted (US-9, done).
- Re-entering only the invalid field instead of cancelling a command (US-10, planned).

**Course requirements** are tracked as technical stories: a test framework (TECH-1), the
five proposal test cases (TECH-2), a coverage report (TECH-3), a complete README (TECH-4),
and design documents that match the code (TECH-5).

## Technical approach

- **Language and interface:** Ruby, command-line only. No server or database is needed to
  run it.
- **Dependencies:** the app uses only Ruby's standard library (`date`, `json`,
  `bigdecimal`). RSpec is used for tests.
- **Storage:** a local JSON file, `data/saved_list.json`.
- **Structure:** four modules with one-way control, CLI → `StorageManager` →
  `SubscriptionManager` → `Subscription` (see `design.md`). Business logic stays out of
  the CLI so it can be unit-tested.

## Collaboration

The team will mainly collaborate individually and asynchronously, communicating on Discord
or Canvas as needed. A pair programming session will be scheduled to gain experience in that
regard.

**Pair programming: done.** The team paired on Sep 12 for the initial planning and the
planning and design documents, and on Sep 13 for the skeleton code (sessions 1 and 2 in
`pairing.md`).

**How work is shared:**

- **Repository:** one GitHub repository; work is committed to `main`
- **Tracking:** each user story has a GitHub issue (linked from the story), and `backlog.md`
  breaks stories into tasks and iterations.
- **Avoiding conflicts:** every command lives in `lib/subtrack.rb`, so pull before starting
  work and commit soon after finishing a task. Tell the other person on Discord before
  starting a task so two people don't edit the same command.
- **Pair programming:** sessions are recorded in `pairing.md` with the driver, navigator,
  role switches, and work completed.

**Who did what so far** 

- Max Moody: set up the project skeleton; worked on the add, update, and delete
  subscription features, writing the functional tests, and the planning document.
- Bansari Patel: worked on the design, backlog, and story documents; the list table,
  search, filter, unique name validation, and crash fixes; and writing the functional
  tests.

## Iterations

Work is planned in short iterations. Each one starts with its blueprint (design) task, and
high-priority stories come first. The full task breakdown is in `backlog.md`.

| Iteration | Goal | Status |
|---|---|---|
| 1 (Sep 12–14) | Project skeleton and first add/list | Done |
| 2 (Sep 15–21) | Full subscription data and planning | Done |
| 3 (Sep 22–27) | Persistence, update, delete, design docs | Done |
| 4 (Sep 28) | Stabilize, finish core features, tests, docs | Done |
| 5 | Automatic persistence (US-7) | Next |
| 6 | Grader readiness (TECH-1, TECH-3) | Planned |
| 7 | Usability (US-10) | Planned |

## Definition of done

### For the project

The core of the project will be "done" when the system can handle adding, deleting, and
listing subscriptions, saving and loading subscription list data, and displaying monthly and
yearly subscription costs.

In practice, this means:

- Core stories US-1 to US-8 are Complete.
- All five proposal test scenarios pass (see the test plan in `backlog.md`).
- A grader can install, run, and test the app using only the README (TECH-4).
- `design.md`, `backlog.md`, and the user stories match the final code (TECH-5).

**Current status:** every core story except US-7 is complete, and all five proposal tests
pass. Manual save/load works, but US-7 requires saving automatically and loading on startup,
which is planned for iteration 5.

### For a user story

A story is Complete only when all of the following are true:

1. Every acceptance criterion in the story is met.
2. The new behavior has automated tests: unit tests for `Subscription` /
   `SubscriptionManager` / `StorageManager` logic, and a functional test for any new or
   changed command.
3. The full test suite passes (`rspec`), not only the new tests.
4. Invalid input is rejected with a clear message and never crashes the app.
5. Any new command is listed in `help` and in the README.
6. The story's status and "Current state" note are updated, along with `backlog.md`, and
   `design.md` if a design decision changed.
7. The work is committed and pushed to `main`.

## Risks

| Risk | Plan |
|---|---|
| Asynchronous work leads to conflicting edits in `lib/subtrack.rb` | Small commits, pull before starting, announce tasks on Discord |
| Scope grows beyond the time available | Essential features first; optional features only once the definition of done is met |
| Features work by hand but break later | Automated unit and functional tests for every story; run the full suite before each commit |
| Save/load only works when started from the project folder | Documented in the README; possible fix listed in the backlog icebox |
