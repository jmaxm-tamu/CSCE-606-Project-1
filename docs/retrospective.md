<!--
(placeholder info)

The team should hold a retrospective discussion near the end of the project and document the discussion in docs/retrospective.md.

The retrospective discussion should address:

- What went well
- What was difficult
- What the pair would improve next time
- Whether the final app met the original goal

Assessment

The retrospective discussion will be assessed based on whether the documentation:

- Is present
- Shows meaningful reflection
- Is specific to the project and consistent with the actual development history


Below document is modified from Bansari's template from Sept 27.
-->

# SubTrack — Retrospective

**Team 15 — Bansari Patel, Max Moody**

## What went well

- The core design held up. Splitting the code into Subscription, SubscriptionManager,
  StorageManager, and CLI meant features could be added without reworking earlier modules.
- The final project contained all the main featues we had planned, giving a simple and satisfting user experience.

## What did not go well

- **Documentation fell behind the code.** Five of the six required documents were still
  incomplete at the checkpoint, and the user stories file held a single story. We treated
  documentation as something to do at the end rather than alongside the work.
- **Design documents created after initial code.** The design document was written after the framework for the code, meaning that it did not inform our decisions in that respect.
- **No test tooling was set up.** The only test checked that the `Subscription` class exists,
  and with no framework in place there was nothing to run, so no feature had real coverage.
- **Contribution was uneven.** All commits at the checkpoint came from one team member, which
  left the other without a record of contribution and concentrated knowledge of the codebase
  in one place.

## What we learned

- Domain rules such as normalizing yearly plans to a monthly equivalent are cheaper to settle
  before coding than to retrofit afterward.
- Test tooling is setup work that has to be scheduled as its own task; it does not happen
  incidentally while writing features.
- Documentation written at the end is both worse and more expensive than documentation
  written as the work happens.
- Work has to be split so that each person owns something end to end, or one person absorbs
  the whole project by default.
