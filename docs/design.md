# SubTrack — Design Document

**Team 15 — Bansari Patel, Max Moody**
CSCE 606 Software Engineering, Project 1

## 1. Purpose

SubTrack is a command-line application for managing recurring subscriptions such as
streaming services, software, gym memberships, and similar services. It lets a user add,
view, search, update, and delete subscriptions while tracking estimated monthly and yearly
costs, and it saves that data between sessions.

## 2. Intended users and problem

The intended users are individuals with several recurring subscriptions signed up for at
different times and billed on different cycles. Charges are spread across apps, emails, and
bank statements, and because some plans are monthly and others yearly, the true recurring
total is hard to see. SubTrack puts every subscription in one place and reports what they
cost together.

## 3. Architecture
ac
Control passes in one direction through four modules:

```
User (terminal) --> CLI --> StorageManager --> SubscriptionManager --> Subscription
```

| Module | Responsibility | Key data / operations |
|---|---|---|
| `Subscription` | Represents one subscription and validates its own fields | name, cost, billing frequency, category, renewal date |
| `SubscriptionManager` | Owns the collection and all business logic | add, search, filter, update, delete, monthly/yearly totals |
| `StorageManager` | Loads and saves subscription data between sessions | save, load |
| `CLI` | Commands, prompts, input checks, formatted output | command loop, `help` |

The user only interacts with the CLI. The CLI calls `StorageManager`, which loads the saved
data and writes it back. `StorageManager` passes that data to `SubscriptionManager`, which
performs the logic and works with individual `Subscription` records.

## 4. Design decisions and justification

**Separation of logic from input/output.** `SubscriptionManager` never prints and the CLI
never reads or writes the data file directly. This keeps the business logic testable without
simulating a terminal session.

**Normalization to a monthly cost.** Every plan is converted to a monthly equivalent before
totals are computed, so plans on different billing cycles can be summed. The yearly total is
the monthly total multiplied by twelve. Example: Netflix at $20/month, Spotify at $10/month,
and Amazon Prime at $120/year give $40/month and $480/year.

**Validation in the model.** `Subscription` validates its own fields, so invalid data such as
a negative cost is rejected regardless of which code path creates the record.

**Plain-file persistence.** Data is stored in a local [JSON/CSV] file rather than a database.
A command-line tool should not require a server to run, the file is human-readable for
debugging, and it is loaded on startup and written back on save.

## 5. User interface

SubTrack uses a command-driven CLI. The user types a command such as `add`, `list`, or
`search`; a `help` command lists every available command and how to run it, so nothing has to
be memorized. Each core feature maps to a single command.

UI decisions:

- **Commands with built-in help** — no syntax to memorize, familiar to terminal users.
- **Fail fast on invalid input** — an invalid value reports the problem and cancels the
  command rather than storing bad data. (Re-prompting for only the invalid field is a
  candidate improvement; see the backlog.)
- **Aligned table output** — lists and summaries print in columns so costs are easy to scan.
- **Plain-language results** — an empty search reports "Subscription not found." rather than
  printing nothing.

Example workflow, adding a subscription:

1. The user runs `add`.
2. SubTrack prompts for name, cost, billing frequency, category, and renewal date.
3. An invalid value reports the error and cancels the command.
4. On valid input, the subscription is confirmed, listed, and saved.

## 6. Data model

A subscription record holds:

| Field | Type | Validation |
|---|---|---|
| name | text | non-empty |
| cost | number | greater than zero |
| billing frequency | monthly or yearly | must be one of the allowed values |
| category | text | non-empty |
| renewal date | date (YYYY-MM-DD) | must parse as a valid date |

## 7. Testing approach

Test framework: [RSpec / pytest / other]. Tests cover the five scenarios from the project
proposal, one per core feature: add with validation, search including the not-found case,
update and delete, the spending summary calculation, and persistence across a restart. See
`tests/` and the test plan in the backlog.

## 8. Future work

Stretch features not in the current scope: subscriptions renewing in the next 7 or 30 days,
spending summaries grouped by category, and sorting by name, cost, category, or renewal date.
