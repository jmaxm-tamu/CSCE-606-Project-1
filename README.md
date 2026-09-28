# SubTrack

SubTrack is a command-line application for keeping track of recurring subscriptions such as
streaming services, software, and gym memberships. You can add, list, search, filter,
update, and delete subscriptions, each with a cost, billing frequency (monthly or yearly),
category, and renewal date, and save your list to a file so it is still there next time.

## Requirements

- Ruby 3.0 or newer (developed and tested with Ruby 3.2.3). Check with `ruby -v`.
- RSpec, only needed to run the tests (see [How to test](#how-to-test)).

The app itself uses only Ruby's standard library, so nothing else needs to be installed to
run it.

## Installation

```bash
git clone https://github.com/jmaxm-tamu/CSCE-606-Project-1.git
cd CSCE-606-Project-1
```

If you download the project as a ZIP from GitHub instead, the folder is named
`CSCE-606-Project-1-main`. **Rename it to `CSCE-606-Project-1`**, or `save` and `load` will
not work (see [Known limitations](#known-limitations)).

## How to run

**1. Open a terminal** (Terminal on macOS, a shell on Linux, or PowerShell / Command Prompt
on Windows).

**2. Check that Ruby is installed:**

```bash
ruby -v
```

You should see `ruby 3.0` or newer. If the command is not found or the version is older,
install Ruby first:

- **macOS:** `brew install ruby` (with [Homebrew](https://brew.sh)), or use rbenv
- **Linux (Debian/Ubuntu):** `sudo apt install ruby-full`
- **Windows:** download the installer from [rubyinstaller.org](https://rubyinstaller.org)

**3. Go to the project root folder** (the folder that contains `lib/`, `spec/`, and this
README):

```bash
cd CSCE-606-Project-1
```

**4. Start SubTrack:**

```bash
ruby lib/subtrack.rb
```

SubTrack prints a welcome message and waits for a command:

```
Welcome to Subtrack!
This is a system for cataloguing, tracking, and saving your current subscriptions.
Type 'h' for help.
```

**5. Type a command and press Enter.** Start with `h` to see every command, then `add` to
add your first subscription. SubTrack asks for each detail one at a time. The full list of
commands is in the [Commands](#commands) table below.

**6. Save before you quit.** Type `save` to write your list to `data/saved_list.json`, then
`quit` (or `q`) to exit. Anything not saved is lost when you quit.

**7. Next time**, start SubTrack the same way (step 4) and type `load` to get your saved
subscriptions back.

**Where to start it from:** SubTrack must be started from the project root
(`CSCE-606-Project-1`) or its `lib` folder (`cd lib` then `ruby subtrack.rb`) for `save`
and `load` to work. From any other folder, the app still runs, but `save` and `load`
print an error.

### Commands

| Command | Shortcut | What it does |
|---|---|---|
| `add` | `a` | Add a subscription. Prompts for name, cost, category (optional), billing frequency (`month` or `year`), and renewal date (`YYYY-MM-DD`). Names must be unique, ignoring case (`netflix` is rejected if `Netflix` exists, but `Netflix Premium` is allowed). |
| `list` | `l` | Show all subscriptions in a table. |
| `search` | | Find subscriptions by name. Ignores case and matches part of a name (`net` finds `Netflix`). Prints "Subscription not found." if nothing matches. |
| `filter` | | Show every subscription in one category. Ignores case; enter `N/A` for subscriptions with no category. |
| `summary` | | Show your estimated monthly and yearly cost. Yearly plans count as 1/12 of their price per month. |
| `update` | | Change the cost of a subscription, found by its full name (ignoring case). |
| `delete` | | Delete a subscription, found by its full name (ignoring case), after a `y`/`yes` confirmation. |
| `save` | | Save the list to `data/saved_list.json` (the `data` folder is created automatically). |
| `load` | | Load the list from `data/saved_list.json`, replacing the current list. |
| `help` | `h` | List all commands. |
| `quit` | `q` | Exit SubTrack. **Unsaved changes are lost**, so run `save` first. |

### Example session

Output shortened: SubTrack also prints instructions before each prompt and "Awaiting next
input:" after each command.

```
$ ruby lib/subtrack.rb
Welcome to Subtrack!
...
add
Enter subscription name:
Netflix
Enter subscription cost (dollars and cents):
24.99
Enter subscription category (or leave blank):
Streaming
Enter billing frequency ('month' or 'year'):
month
Enter next renewal date (YYYY-MM-DD format):
2026-10-01
Subscription Netflix added successfully.

list
Displaying subscription list:
Name     Cost    Frequency  Category   Renewal
-------  ------  ---------  ---------  ----------
Netflix  $24.99  month      Streaming  2026-10-01

save
quit
Thank you for using SubTrack!
```

Next time, run `load` to get your saved subscriptions back.

## How to test

Install RSpec once:

```bash
gem install rspec
```

Then from the project root run:

```bash
rspec
```

If your shell says `rspec: command not found` right after installing and you use rbenv, run
`rbenv rehash` and try again.

This runs every test. Expected result: `107 examples, 0 failures`.

To run one test file:

```bash
rspec spec/subscription_spec.rb
```

| Test file | Type | What it covers |
|---|---|---|
| `spec/subscription_spec.rb` | Unit | `Subscription`: fields, defaults, validation, cost updates, yearly cost, JSON output |
| `spec/subscription_manager_spec.rb` | Unit | `SubscriptionManager`: add, update, delete, search, filter, monthly and yearly cost totals, list formatting |
| `spec/subtrack_functional_spec.rb` | Functional | Runs the real app and types commands into it: add, list, search, filter, summary, update, delete, save/load across restarts, help |

The functional tests run each SubTrack session inside a temporary folder, so they never
change your real `data/saved_list.json`.

## Features

- Add subscriptions with name, cost, billing frequency, category, and renewal date
- Input validation: empty names, zero/negative/non-numeric costs, costs with more than two
  decimal places, invalid frequencies, and invalid dates are rejected with a clear message
- Unique subscription names (ignoring case), so totals are never double-counted
- List all subscriptions in an aligned table
- Search by name (case-insensitive, partial matches) and filter by category
- Estimated monthly and yearly cost across all subscriptions, with yearly plans converted to
  a monthly equivalent
- Update a subscription's cost
- Delete a subscription, with confirmation
- Save to and load from a JSON file
- Built-in help listing every command

## Known limitations

- **Saving is manual.** Nothing is saved automatically, and the saved list is not loaded
  on startup. Run `save` before `quit`, and `load` after starting.
- **Folder name matters.** `save` and `load` only work when SubTrack is started from a
  folder named exactly `CSCE-606-Project-1` (or its `lib` folder). From any other folder
  they print an error.
- **`update` changes only the cost.** To change the name, frequency, category, or
  renewal date, delete the subscription and add it again.
- **One mistake cancels the command.** An invalid value cancels the whole `add` or
  `update`, and you have to start again.
- **A damaged save file crashes the app.** If `data/saved_list.json` is edited by hand and
  is no longer valid JSON, or contains invalid values, `load` stops the program with an
  error.
- **Ctrl-D in the middle of a prompt crashes the app.** Ctrl-D at the main command prompt
  exits cleanly.

## Team members

- Bansari Patel
- Max Moody
