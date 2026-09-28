# SubTrack — User Stories

**Team 15 — Bansari Patel, Max Moody**

Point scale: 1 = trivial, 2 = small, 3 = moderate, 5 = large.
Status values: Not started / In progress / Complete.

---

## US-1 — View all subscriptions

As a subscriber, I want to view all of my subscriptions in a single list so that I can see
everything I'm signed up for at a glance.

- **Points:** 1
- **Status:** In progress
- **Issue:** https://github.com/jmaxm-tamu/CSCE-606-Project-1/issues/2
- **Acceptance criteria:**
  - Running the list command prints every stored subscription.
  - Each row shows name, cost, billing frequency, category, and renewal date.
  - With no subscriptions stored, a clear message is printed rather than an empty list.

## US-2 — Search and filter subscriptions

As a subscriber, I want to search and filter my subscriptions by name or category so that I
can quickly locate a specific subscription.

- **Points:** 3
- **Status:** In progress
- **Issue:** https://github.com/jmaxm-tamu/CSCE-606-Project-1/issues/3
- **Acceptance criteria:**
  - Searching an existing name returns that subscription's details.
  - Filtering by category returns every subscription in that category.
  - A search with no matches prints "Subscription not found."

## US-3 — Add a subscription

As a subscriber, I want to add a subscription with its name, cost, billing frequency,
category, and renewal date so that I can start tracking it.

- **Points:** 3
- **Status:** [Not started / In progress / Complete]
- **Issue:** [#]
- **Acceptance criteria:**
  - All five fields are prompted for.
  - The new subscription appears in the list afterward.
  - A negative or non-numeric cost is rejected with a clear message.
  - An unparseable renewal date is rejected with a clear message.

## US-4 — Update a subscription

As a subscriber, I want to update an existing subscription so that my records stay accurate
when a price or plan changes.

- **Points:** 2
- **Status:** [Not started / In progress / Complete]
- **Issue:** [#]
- **Acceptance criteria:**
  - An existing subscription can be located and edited.
  - The changed value is reflected in the list and in the stored data.
  - The same validation rules as adding apply to edited values.

## US-5 — Delete a subscription

As a subscriber, I want to delete a subscription so that cancelled services stop counting
toward my totals.

- **Points:** 2
- **Status:** [Not started / In progress / Complete]
- **Issue:** [#]
- **Acceptance criteria:**
  - A named subscription can be removed.
  - After deletion it no longer appears in the list or in searches.
  - Deleting a subscription that does not exist reports it clearly.

## US-6 — See estimated monthly and yearly cost

As a subscriber, I want to see my estimated monthly and yearly subscription spend so that I
understand what my recurring costs actually add up to.

- **Points:** 3
- **Status:** [Not started / In progress / Complete]
- **Issue:** [#]
- **Acceptance criteria:**
  - Yearly plans are converted to a monthly equivalent before summing.
  - Both a monthly total and a yearly total are reported.
  - Netflix $20/month, Spotify $10/month, Amazon Prime $120/year gives $40/month and
    $480/year.

## US-7 — Keep my subscriptions between sessions

As a subscriber, I want my subscriptions saved automatically so that my data is still there
the next time I open the application.

- **Points:** 3
- **Status:** [Not started / In progress / Complete]
- **Issue:** [#]
- **Acceptance criteria:**
  - Data is written to a local file when changed or on exit.
  - Existing data is loaded on startup.
  - A subscription added, then the app closed and reopened, is still present.

## US-8 — Discover available commands

As a subscriber, I want a help command that lists every command and how to run it so that I
don't have to memorize the interface.

- **Points:** 1
- **Status:** [Not started / In progress / Complete]
- **Issue:** [#]
- **Acceptance criteria:**
  - The help command lists every supported command with a one-line description.
  - Help is reachable at any point in the session.

---

**Total points:** 18
**Completed points:** [ ]
