# SubTrack — User Stories (Complete Set)

**Team 15 — Bansari Patel, Max Moody**

Point scale: 1 = trivial, 2 = small, 3 = moderate, 5 = large.
Status values: Not started / In progress / Complete.

Stories are grouped as:

1. **Core stories (US-1 to US-8)**: the original stories. The project is "done" when these
   are complete (see `planning.md`).
2. **Robustness stories (US-9 and US-10)**: gaps found in the code that make the core
   features unreliable.
3. **Technical stories (TECH-1 to TECH-5)**: testing and documentation the course requires.

Stretch features (upcoming renewals, sorting, spending by category) are listed as future work
in section 8 of `design.md`.

---

## Core stories

## US-1 — View all subscriptions

As a subscriber, I want to view all of my subscriptions in a single list so that I can see
everything I'm signed up for at a glance.

- **Points:** 1
- **Status:** Complete
- **Issue:** https://github.com/jmaxm-tamu/CSCE-606-Project-1/issues/2
- **Acceptance criteria:**
  - Running the list command prints every stored subscription.
  - Each row shows name, cost, billing frequency, category, and renewal date.
  - With no subscriptions stored, a clear message is printed rather than an empty list.
- **Current state:** `list` (or `l`) prints an aligned table. Blank categories show as `N/A`.
  An empty list prints "Subscription list empty."

## US-2 — Search and filter subscriptions

As a subscriber, I want to search and filter my subscriptions by name or category so that I
can quickly locate a specific subscription.

- **Points:** 3
- **Status:** Complete
- **Issue:** https://github.com/jmaxm-tamu/CSCE-606-Project-1/issues/3
- **Acceptance criteria:**
  - Searching an existing name returns that subscription's details.
  - Filtering by category returns every subscription in that category.
  - A search with no matches prints "Subscription not found."
- **Current state:** `search` finds subscriptions by name, ignoring case and matching part of
  a name (`net` finds `Netflix`). `filter` shows every subscription in a category, ignoring
  case, and `N/A` finds subscriptions with no category. Both print their results as a table.
  Backed by `SubscriptionManager#search_subscriptions` and `#filter_by_category`. Proposal
  test 2 passes.

## US-3 — Add a subscription

As a subscriber, I want to add a subscription with its name, cost, billing frequency,
category, and renewal date so that I can start tracking it.

- **Points:** 3
- **Status:** Complete
- **Issue:** [#]
- **Acceptance criteria:**
  - All five fields are prompted for.
  - The new subscription appears in the list afterward.
  - A negative or non-numeric cost is rejected with a clear message.
  - An unparseable renewal date is rejected with a clear message.
- **Current state:** Done. Zero costs and costs with more than two decimal places are also
  rejected, and so are duplicate names (US-9). Category is optional, as documented in the
  data model in `design.md`.

## US-4 — Update a subscription

As a subscriber, I want to update an existing subscription so that my records stay accurate
when a price or plan changes.

- **Points:** 2
- **Status:** Complete
- **Issue:** https://github.com/jmaxm-tamu/CSCE-606-Project-1/issues/4
- **Acceptance criteria:**
  - An existing subscription can be located and edited.
  - The changed value is reflected in the list and in the stored data.
  - The same validation rules as adding apply to edited values.
- **Current state:** `update` can change only the **cost**. A change of plan (billing
  frequency), category, or renewal date is not supported yet. The change reaches the stored
  data only after a manual `save` (see US-7).

## US-5 — Delete a subscription

As a subscriber, I want to delete a subscription so that cancelled services stop counting
toward my totals.

- **Points:** 2
- **Status:** Complete
- **Issue:** https://github.com/jmaxm-tamu/CSCE-606-Project-1/issues/5
- **Acceptance criteria:**
  - A named subscription can be removed.
  - After deletion it no longer appears in the list or in searches.
  - Deleting a subscription that does not exist reports it clearly.
- **Current state:** Done, with a y/yes confirmation step. The yearly cost total is reduced
  when a subscription is deleted, and a functional test checks that `search` no longer finds
  it.

## US-6 — See estimated monthly and yearly cost

As a subscriber, I want to see my estimated monthly and yearly subscription spend so that I
understand what my recurring costs actually add up to.

- **Points:** 3
- **Status:** Complete
- **Issue:** https://github.com/jmaxm-tamu/CSCE-606-Project-1/issues/6
- **Acceptance criteria:**
  - Yearly plans are converted to a monthly equivalent before summing.
  - Both a monthly total and a yearly total are reported.
  - Netflix $20/month, Spotify $10/month, Amazon Prime $120/year gives $40/month and
    $480/year.
- **Current state:** The `summary` command prints the estimated monthly and yearly cost.
  `SubscriptionManager#year_cost` keeps the yearly total through add, update, delete, and
  load, and `#month_cost` spreads it over 12 months. Proposal test 4 ($40/month, $480/year)
  passes.

## US-7 — Keep my subscriptions between sessions

As a subscriber, I want my subscriptions saved automatically so that my data is still there
the next time I open the application.

- **Points:** 3
- **Status:** In progress
- **Issue:** https://github.com/jmaxm-tamu/CSCE-606-Project-1/issues/7
- **Acceptance criteria:**
  - Data is written to a local file when changed or on exit.
  - Existing data is loaded on startup.
  - A subscription added, then the app closed and reopened, is still present.
- **Current state:** Manual `save` and `load` commands work and write
  `data/saved_list.json`. Nothing is saved automatically, and nothing is loaded on startup
  (`StorageManager#initialize` has a comment saying "if saved list exists, load that list").
  Anything the user doesn't explicitly save is lost when they quit.

## US-8 — Discover available commands

As a subscriber, I want a help command that lists every command and how to run it so that I
don't have to memorize the interface.

- **Points:** 1
- **Status:** Complete
- **Issue:** https://github.com/jmaxm-tamu/CSCE-606-Project-1/issues/8
- **Acceptance criteria:**
  - The help command lists every supported command with a one-line description.
  - Help is reachable at any point in the session.
- **Current state:** `help` (or `h`) lists all ten commands, and unknown commands point
  the user to `h`. Any new command must also be added to `help`.

---

## Robustness stories

## US-9 — Prevent duplicate subscriptions

As a subscriber, I want SubTrack to stop me from adding the same subscription twice so that
my totals aren't inflated and update/delete always change the subscription I mean.

- **Points:** 2
- **Status:** Complete
- **Issue:** https://github.com/jmaxm-tamu/CSCE-606-Project-1/issues/9
- **Acceptance criteria:**
  - Adding a subscription whose name already exists (ignoring case) is rejected with a clear
    message.
  - Update and delete match names without regard to case ("netflix" finds "Netflix").
  - Loading a saved file never creates duplicates.
- **Current state:** `add` rejects a name that already exists, ignoring case, right after the
  name is entered. Names that only contain an existing name are allowed (`Netflix Premium`
  next to `Netflix`). `update` and `delete` find the full name ignoring case and report a
  missing name before asking for anything else. `load` skips duplicates in a saved file and
  prints a warning for each. Backed by `SubscriptionManager#find_subscription`.

## US-10 — Re-enter only the invalid field

As a subscriber, I want to be asked again for just the field I got wrong so that one typo
doesn't make me retype the whole subscription.

- **Points:** 2
- **Status:** Not started
- **Issue:** [#]
- **Acceptance criteria:**
  - An invalid value shows the error and asks for that field again.
  - Fields that were already entered correctly are kept.
  - The user can cancel the command (for example by entering a blank line or `cancel`).
- **Current state:** Any invalid value cancels the whole `add` or `update` command (the
  "fail fast" choice in `design.md`, section 5).

---

## Technical stories

## TECH-1 — Set up the test framework

As a developer, I want an automated test framework so that I can check changes without
testing by hand.

- **Points:** 2
- **Status:** In progress
- **Issue:** [#]
- **Acceptance criteria:**
  - RSpec is installed through a `Gemfile`, so `bundle install` sets everything up.
  - `rspec` from the project root runs every test.
  - Unit tests cover `Subscription` and `SubscriptionManager`; functional tests cover the CLI.
- **Current state:** RSpec specs exist for `Subscription`, `SubscriptionManager`, and the CLI.
  There is no `Gemfile`; RSpec is installed with `gem install rspec`.

## TECH-2 — Write the five proposal test cases

As a team, we want automated tests for the five proposal scenarios so that we can show every
core feature works.

- **Points:** 3
- **Status:** Complete
- **Issue:** [#]
- **Acceptance criteria:**
  - Tests exist and pass for: add with validation, search with a not-found case,
    update then delete, the $40/month and $480/year summary, and persistence across a
    restart.
- **Current state:** All five pass in `spec/subtrack_functional_spec.rb`.

## TECH-3 — Report test coverage

As a developer, I want a test coverage report so that I can see which code the tests don't
reach.

- **Points:** 2
- **Status:** Not started
- **Issue:** [#]
- **Acceptance criteria:**
  - Running the tests produces a coverage report (for example with SimpleCov) in
    `coverage/`.
  - `coverage/` is listed in `.gitignore`.
  - The README explains how to generate and open the report.
- **Current state:** No coverage tool is set up. The course README requirements ask for
  instructions on generating a coverage report.

## TECH-4 — Complete the README

As a grader, I want the README to explain how to install, run, and test SubTrack so that I
can check the project using only the README.

- **Points:** 1
- **Status:** Complete
- **Issue:** [#]
- **Acceptance criteria:**
  - Covers installation, running the app, and running the tests.
  - Lists the main features and every command.
  - Lists known limitations and all team members.
- **Current state:** The README covers installation, running the app, every command,
  running the tests, features, known limitations, and team members.

## TECH-5 — Keep the design documents consistent with the code

As a grader, I want the design documents to match the finished app so that they accurately
describe what was built.

- **Points:** 1
- **Status:** Complete
- **Issue:** [#]
- **Acceptance criteria:**
  - `design.md` names the real storage format (JSON) and test framework (RSpec) instead of
    placeholders.
  - The test location in `design.md` is `spec/`, not `tests/`.
  - The data model matches the code (whether category is optional).
  - `backlog.md` and `user_stories.md` statuses match the code.
- **Current state:** `design.md` names JSON and RSpec, points to `spec/`, describes the
  actual architecture, commands, and validation, and lists category as optional.
  `backlog.md` statuses match the stories in this file.

---

