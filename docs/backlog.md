# SubTrack — Product Backlog

**Team 15 — Bansari Patel, Max Moody**

Items are ordered by priority. Stories are defined in `user_stories.md`.

## In progress

| ID | Item | Points | Notes |
|---|---|---|---|---|
| US-1 | View all subscriptions | 3 | 
| US-2 | Search and filter subscriptions | 3 |

## Ready for this iteration

| ID | Item | Points | Notes |
|---|---|---|---|---|
| US-3 | Add a subscription | 3 | Blocks US-1, US-2 in practice |
| US-7 | Persistence between sessions | 3 | Needed for the persistence test |
| US-6 | Monthly and yearly cost totals | 3 | Core differentiator |
| TECH-1 | Set up test framework ([RSpec/pytest]) | 2 | Nothing runnable today |
| TECH-2 | Write the five proposal test cases | 3 | Depends on TECH-1 |

## Next

| ID | Item | Points | Notes |
|---|---|---|---|---|
| US-4 | Update a subscription | 2 | |
| US-5 | Delete a subscription | 2 | |
| US-8 | Help command | 1 | Partially implemented |
| TECH-3 | Re-prompt the invalid field instead of cancelling the command | 2 | UX improvement noted in design doc |

## Test plan

The five scenarios from the project proposal, one per core feature:

1. **Add** — add Netflix at $24.99/month, then attempt a negative price. Expect Netflix listed
   and the negative price rejected.
2. **Search** — add Netflix and Spotify, search Netflix, then search a name that does not
   exist. Expect the details returned, then "Subscription not found."
3. **Update / delete** — change Netflix from $19.99 to $24.99, then delete it. Expect the new
   price shown, then Netflix no longer found.
4. **Summary** — Netflix $20/month, Spotify $10/month, Amazon Prime $120/year. Expect $40 per
   month and $480 per year.
5. **Persistence** — add Netflix, close the application, restart it. Expect Netflix loaded
   from storage.
