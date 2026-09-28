# SubTrack — Pairing and Work Log

**Team 15 — Bansari Patel, Max Moody**

This log has three parts:

1. **Work log so far**: what was built and by whom. The initial planning and the skeleton
   code were done in pairs (sessions 1 and 2); the rest so far was done individually.
2. **Pairing plan**: the remaining work from `backlog.md`, split into pairing sessions.
3. **Session log**: one entry per pairing session, filled in right after the session.

---

## 1. Work log so far

| Date | Author | Work |
|---|---|---|
| Sep 12 | Max Moody | Created the repository and placeholder docs |
| Sep 12 | Bansari Patel and Max Moody (pair, session 1) | Initial planning; started the planning and design documents |
| Sep 13 | Bansari Patel and Max Moody (pair, session 2) | Skeleton code: the `Subscription`, `SubscriptionManager`, and `StorageManager` classes, the CLI command loop with `help` and `quit`, and the first spec (committed by Max on Sep 14) |
| Sep 14 | Max Moody | Added the `add` and `list` commands |
| Sep 14 | Bansari Patel | summary, functional tests, README, updated docs |
| Sep 14 | Max Moody | Wrote the first user story |
| Sep 17 | Max Moody | Added frequency, category, and renewal date, with validation |
| Sep 21 | Max Moody | Wrote the planning document |
| Sep 22 | Bansari Patel | Design, backlog, and user story documents |
| Sep 23–24 | Max Moody | Added saving and loading as JSON |
| Sep 27 | Max Moody | Added the `update` and `delete` commands and the yearly cost total |
| Sep 28 | Bansari Patel | Crash fixes and aligned table output for `list` |
| Sep 28 | Bansari Patel | Search, filter, unique names, unit and functional tests, update README, updated docs |

---

## 2. Pairing plan

**How we pair:**

- **Roles:** the driver types; the navigator reviews each line, watches for bugs and edge
  cases, and keeps the backlog task and acceptance criteria in view.
- **Switching:** switch roles at every task boundary, or every 25–30 minutes, whichever comes
  first. Each person drives at least once per session.
- **Design first:** each session starts with the blueprint task for that iteration, which is
  discussed and agreed before any code is written.
- **Shared understanding:** before the session ends, the navigator explains the code just
  written back to the driver.
- **Evidence:** commits made during a session include a co-author line for the navigator,
  so shared ownership shows in the git history:

  ```
  Co-authored-by: Name <email>
  ```

| Session | Iteration | Backlog tasks | Planned first driver | Planned first navigator |
|---|---|---|---|---|
| 3 | — | Code walkthrough: each person explains the code the other wrote (see below) | Max | Bansari |
| 4 | 5 | 5.1 decide when to save, 5.2 load on startup, 5.3 save automatically | Bansari | Max |
| 5 | 5 | 5.4 help, 5.5 `StorageManager` tests, 5.6 functional tests, 5.7 docs | Max | Bansari |
| 6 | 6 | 6.1–6.5 install decision, coverage report, README, fresh-clone check | Bansari | Max |
| 7 | 7 | 7.1–7.3 prompt helper and using it in `add` and `update` | Max | Bansari |
| 8 | 7 | 7.4–7.6 Ctrl-D in prompts, tests, docs | Bansari | Max |

**Why session 3 is a walkthrough:** the course assesses whether both partners can explain the
design and implementation. The skeleton was written together in session 2, but since then
Max wrote save/load, update, and delete, and Bansari wrote search, filter, summary, unique
names, and the tests. Each person should be
able to explain all of it.

- Max drives: walks through `Subscription` validation, `StorageManager` save/load, and
  `update`/`delete`, while Bansari asks questions.
- Switch. Bansari drives: walks through `search`/`filter`, `summary` and `month_cost`,
  `find_subscription` and unique names, and how the functional tests run the real app in a
  temporary folder.
- Together: run the full test suite and read the output of one failing test on purpose
  (change an expected value, run it, change it back).

---

## 3. Session log

Fill in each entry right after the session. Leave "Status: Planned" until the session
happens.

### Session 1: Initial planning, planning and design documents

- **Status:** Done
- **Date:** Sep 12
- **Duration:**
- **Driver → navigator:** both; roles switched partway through
- **Role switches:**
- **Work completed:**
  - Initial planning discussion: what app to build, essential and optional features, how
    to collaborate, and what "done" means (recorded in `planning.md`)
  - Started the planning document and the design document
- **Decisions and notes:**
  - Build SubTrack, a subscription tracking app (`planning.md`)
  - Essential features: add, delete, and list subscriptions; save between sessions;
    monthly and yearly costs. Search, filter, renewals, sorting, and category costs are
    optional (`planning.md`)
  - Work mainly individually and asynchronously, with pair sessions as well
    (`planning.md`)
- **Commits:** none during the session; the planning document was committed on Sep 21 and
  the design documents on Sep 28

### Session 2: Skeleton code

- **Status:** Done
- **Date:** Sep 13
- **Duration:**
- **Driver → navigator:** both; roles switched partway through
- **Role switches:**
- **Work completed:**
  - Created the `Subscription`, `SubscriptionManager`, and `StorageManager` classes, with
    save/load stubs
  - Created the CLI (`lib/subtrack.rb`) command loop with `help` and `quit`
  - Wrote the first RSpec test
- **Decisions and notes:**
  - Split the code into a model (`Subscription`), business logic (`SubscriptionManager`),
    storage (`StorageManager`), and the CLI, as described in `design.md`
- **Commits:** committed by Max on Sep 14
