# SubTrack — Design Document

**Team 15 — Bansari Patel, Max Moody**
CSCE 606 Software Engineering, Project 1

## 1. Purpose

SubTrack is a command-line application for managing recurring subscriptions such as
streaming services, software, gym memberships, and similar services. It lets a user add,
list, search, filter, update, and delete subscriptions, shows estimated monthly and yearly
costs, and saves the list to a file so it can be loaded in a later session.

## 2. Intended users and problem

The intended users are individuals with several recurring subscriptions signed up for at
different times and billed on different cycles. Charges are spread across apps, emails, and
bank statements, and because some plans are monthly and others yearly, the true recurring
total is hard to see. SubTrack puts every subscription in one place and reports what they
cost together.

## 3. Architecture

Control passes in one direction through four modules:

```
User (terminal) --> CLI --> StorageManager --> SubscriptionManager --> Subscription
```

| Module | File | Responsibility | Key data / operations |
|---|---|---|---|
| `Subscription` | `lib/subscription.rb` | Represents one subscription and validates its own fields | name, cost, billing frequency, category, renewal date; yearly cost; JSON conversion |
| `SubscriptionManager` | `lib/subscription_manager.rb` | Owns the collection and all business logic | add, find, search, filter, update, delete, monthly/yearly totals, table formatting |
| `StorageManager` | `lib/storage_manager.rb` | Saves and loads the collection as JSON | save, load, save-file location |
| CLI | `lib/subtrack.rb` | Command loop, prompts, input checks, printed output | one method per command, `help` |

The user only interacts with the CLI. The CLI creates one `StorageManager`, which owns the
current `SubscriptionManager`. Commands reach the collection through
`storage_manager.subscription_manager`. On `load`, `StorageManager` builds a new
`SubscriptionManager` from the file and replaces the old one, so the CLI always works with
the current list.

## 4. Design decisions and justification

**Separation of logic from input/output.** The CLI does all prompting and reading of input,
and never reads or writes the data file directly. `SubscriptionManager` returns data or
strings (`search_subscriptions`, `filter_by_category`, `format_table`) rather than printing,
so its logic can be unit-tested without simulating a terminal. Two methods still print:
`list_subscriptions` prints the formatted table, and `update_subscription` prints an error if
it is given an invalid cost (the CLI checks the cost first, so this does not happen in
normal use).

**Normalization of costs.** Each subscription converts its own cost to a yearly amount
(`Subscription#yearly_cost`: monthly plans × 12, yearly plans as-is).
`SubscriptionManager` keeps a running yearly total that is adjusted on every add, update,
delete, and load, and the monthly total is the yearly total ÷ 12. Plans on different
billing cycles can therefore be summed. Example: Netflix at $20/month, Spotify at
$10/month, and Amazon Prime at $120/year give $480/year and $40/month.

**Validation in two layers.** `Subscription` validates its own fields (non-empty name,
positive cost, `month` or `year` frequency), so invalid data is rejected whichever code path
creates the record, including `load`. The CLI checks each value as it is typed (cost is a
number with at most two decimal places, date is `YYYY-MM-DD`) so it can give a specific
message before anything is created.

**Unique names.** `SubscriptionManager` rejects a name that already exists, ignoring case,
and `update`/`delete` find subscriptions by their full name, ignoring case. This keeps
totals from being double-counted and guarantees that `update` and `delete` affect exactly
one subscription. Only the full name is compared, so `Netflix` and `Netflix Premium` are
different subscriptions.

**Plain-file persistence.** Data is stored in a local JSON file, `data/saved_list.json`,
rather than a database. A command-line tool should not need a server to run, the file is
human-readable for debugging, and Ruby's standard library reads and writes JSON with no
extra gems. Saving and loading are manual (`save` and `load` commands). Saving
automatically and loading on startup are planned (US-7). The file location is based on the
folder SubTrack is started from, which must be the project root or its `lib` folder.

## 5. User interface

SubTrack uses a command-driven CLI. The user types a command such as `add`, `list`, or
`search`, and a `help` command lists every available command, so nothing has to be
memorized. Each feature maps to a single command:

| Command | Purpose |
|---|---|
| `add` (`a`) | Add a subscription |
| `list` (`l`) | Show all subscriptions |
| `search` | Find subscriptions by name (case-insensitive, partial match) |
| `filter` | Show subscriptions in one category (`N/A` for no category) |
| `summary` | Show estimated monthly and yearly cost |
| `update` | Change a subscription's cost |
| `delete` | Delete a subscription, after confirmation |
| `save` / `load` | Write the list to, or read it from, `data/saved_list.json` |
| `help` (`h`) | List all commands |
| `quit` (`q`) | Exit |

UI decisions:

- **Commands with built-in help**: no syntax to memorize, familiar to terminal users.
  Unknown commands point the user to `help`.
- **Fail fast on invalid input**: an invalid value reports the problem and cancels the
  command rather than storing bad data. (Re-prompting for only the invalid field is a
  candidate improvement; see US-10.)
- **Check the name first**: `add` rejects a duplicate name, and `update`/`delete` report a
  missing name, right after the name is entered, before asking for anything else.
- **Aligned table output**: `list`, `search`, and `filter` print the same column-aligned
  table (name, cost, frequency, category, renewal date) so costs are easy to scan. An empty
  category is shown as `N/A`.
- **Plain-language results**: an empty search reports "Subscription not found." and an
  empty list reports "Subscription list empty." rather than printing nothing.
- **Confirm destructive actions**: `delete` asks for `y`/`yes` before removing anything.

Example workflow, adding a subscription:

1. The user runs `add`.
2. SubTrack asks for the name and rejects it at once if it is empty or already exists.
3. SubTrack asks for the cost, category (optional), billing frequency, and renewal date.
4. An invalid value reports the error and cancels the command.
5. On valid input, the subscription is added and SubTrack confirms it. It is written to the
   file the next time the user runs `save`.

## 6. Data model

A subscription record holds:

| Field | Type | Validation |
|---|---|---|
| name | text | non-empty; unique, ignoring case |
| cost | number (dollars) | greater than zero; at most two decimal places when entered |
| billing frequency | `month` or `year` | must be one of the allowed values |
| category | text | optional (shown as `N/A` when empty) |
| renewal date | date (`YYYY-MM-DD`) | must parse as a valid date |

The save file is a JSON array with one object per subscription:

```json
[{"name":"Netflix","cost":24.99,"category":"Streaming","frequency":"month","renewal":"2026-10-01"}]
```

## 7. Testing approach

Test framework: RSpec. Tests live in `spec/` and are run with `rspec` from the project root
(see the README).

| File | Type | Covers |
|---|---|---|
| `spec/subscription_spec.rb` | Unit | `Subscription`: fields, defaults, validation, cost changes, yearly cost, JSON |
| `spec/subscription_manager_spec.rb` | Unit | `SubscriptionManager`: add, duplicates, find, search, filter, update, delete, totals, formatting |
| `spec/subtrack_functional_spec.rb` | Functional | Runs the real CLI with typed input and checks its output for every command |

The functional tests run each session in a temporary folder, so they never change the real
save file. They include the five scenarios from the project proposal, one per core feature:
add with validation, search including the not-found case, update and delete, the spending
summary calculation, and persistence across a restart (see the test plan in `backlog.md`).
All five pass.

## 8. Future work

- Save automatically and load on startup (US-7).
- Re-prompt for only the invalid field instead of cancelling the command (US-10).
- Let `update` change the frequency, category, renewal date, and name, not only the cost.
- Stretch features: subscriptions renewing in the next 7 or 30 days, spending summaries
  grouped by category, and sorting by name, cost, category, or renewal date.
