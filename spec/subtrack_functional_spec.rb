require 'open3'
require 'tmpdir'
require 'fileutils'
require 'json'

# Functional tests: run the real SubTrack CLI, feed it commands on stdin, and check what it prints.
# Each test runs from a fresh temporary folder so save/load never touch the real data/ folder.
describe 'SubTrack CLI' do
  SUBTRACK = File.expand_path('../lib/subtrack.rb', __dir__)

  around do |example|
    Dir.mktmpdir do |tmp|
      # StorageManager#check_dir only allows saving from a folder named CSCE-606-Project-1
      @project_dir = File.join(tmp, 'CSCE-606-Project-1')
      FileUtils.mkdir_p(@project_dir)
      example.run
    end
  end

  # Starts SubTrack, types each line as user input, and returns everything it printed
  def run_subtrack(*lines)
    output, status = Open3.capture2e('ruby', SUBTRACK, stdin_data: lines.join("\n") + "\n", chdir: @project_dir)
    expect(status.success?).to be(true), "SubTrack crashed:\n#{output}"
    output
  end

  # Input lines for adding a subscription through the 'add' prompts
  def add_input(name, cost, category: '', frequency: 'month', renewal: '2026-10-01')
    ['add', name, cost, category, frequency, renewal]
  end

  describe 'add' do
    it 'adds a subscription that then appears in the list' do
      output = run_subtrack(*add_input('Netflix', '24.99', category: 'Streaming'), 'list', 'quit')

      expect(output).to include('Subscription Netflix added successfully.')
      expect(output).to match(/Netflix\s+\$24\.99\s+month\s+Streaming\s+2026-10-01/)
    end

    it 'rejects a negative price and does not add the subscription' do
      output = run_subtrack('add', 'Netflix', '-24.99', 'list', 'quit')

      expect(output).to include('Cost must be a positive number')
      expect(output).to include('Subscription list empty.')
    end

    it 'rejects a zero price' do
      output = run_subtrack('add', 'Netflix', '0', 'quit')
      expect(output).to include('Cost must be a positive number')
    end

    it 'rejects a non-numeric price' do
      output = run_subtrack('add', 'Netflix', 'abc', 'quit')
      expect(output).to include('Cost must be a positive number')
    end

    it 'rejects a price with more than two decimal places' do
      output = run_subtrack('add', 'Netflix', '9.999', 'quit')
      expect(output).to include('cannot have more than two decimal places')
    end

    it 'rejects an empty name' do
      output = run_subtrack('add', '', 'quit')
      expect(output).to include('Name cannot be empty')
    end

    it 'rejects a billing frequency other than month or year' do
      output = run_subtrack('add', 'Netflix', '24.99', '', 'weekly', 'quit')
      expect(output).to include('Billing frequency must be monthly or yearly')
    end

    it 'rejects an unparseable renewal date' do
      output = run_subtrack('add', 'Netflix', '24.99', '', 'month', '2026-13-45', 'list', 'quit')

      expect(output).to include('Renewal date must be in YYYY-MM-DD format')
      expect(output).to include('Subscription list empty.')
    end
  end

  describe 'duplicate names (US-9)' do
    it 'rejects a name that already exists, right after the name is entered' do
      output = run_subtrack(*add_input('Netflix', '20'), 'add', 'Netflix', 'summary', 'quit')

      expect(output).to include("A subscription named 'Netflix' already exists. Use 'update' to change it.")
      expect(output).to include('Estimated yearly cost:  $240.00')
    end

    it 'rejects a name that differs only in case and shows the existing name' do
      output = run_subtrack(*add_input('Netflix', '20'), 'add', 'NETFLIX', 'quit')
      expect(output).to include("A subscription named 'Netflix' already exists.")
    end

    it 'allows a different name that contains an existing one' do
      output = run_subtrack(*add_input('Netflix', '20'), *add_input('Netflix Premium', '30'), 'list', 'quit')

      expect(output).to include('Subscription Netflix Premium added successfully.')
      expect(output).to match(/Netflix\s+\$20\.00/)
      expect(output).to match(/Netflix Premium\s+\$30\.00/)
    end

    it 'skips duplicates in a saved file when loading' do
      FileUtils.mkdir_p(File.join(@project_dir, 'data'))
      saved = [
        { name: 'Netflix', cost: 20, category: '', frequency: 'month', renewal: '2026-10-01' },
        { name: 'netflix', cost: 30, category: '', frequency: 'month', renewal: '2026-10-01' }
      ]
      File.write(File.join(@project_dir, 'data', 'saved_list.json'), JSON.generate(saved))

      output = run_subtrack('load', 'list', 'summary', 'quit')

      expect(output).to include("Skipped duplicate subscription 'netflix' in saved file.")
      expect(output).to match(/Netflix\s+\$20\.00/)
      expect(output).not_to match(/netflix\s+\$30\.00/)
      expect(output).to include('Estimated yearly cost:  $240.00')
    end
  end

  describe 'list' do
    it 'prints a clear message when there are no subscriptions' do
      output = run_subtrack('list', 'quit')
      expect(output).to include('Subscription list empty.')
    end

    it 'shows every subscription with name, cost, frequency, category, and renewal date' do
      output = run_subtrack(
        *add_input('Netflix', '24.99', category: 'Streaming'),
        *add_input('Amazon Prime', '139', frequency: 'year', renewal: '2027-02-03'),
        'list', 'quit'
      )

      expect(output).to match(/Name\s+Cost\s+Frequency\s+Category\s+Renewal/)
      expect(output).to match(/Netflix\s+\$24\.99\s+month\s+Streaming\s+2026-10-01/)
      expect(output).to match(/Amazon Prime\s+\$139\.00\s+year\s+N\/A\s+2027-02-03/)
    end

    it 'works with the short command l' do
      output = run_subtrack(*add_input('Netflix', '24.99'), 'l', 'quit')
      expect(output).to match(/Netflix\s+\$24\.99/)
    end
  end

  describe 'update' do
    it 'changes the cost of an existing subscription' do
      output = run_subtrack(*add_input('Netflix', '19.99'), 'update', 'Netflix', '24.99', 'list', 'quit')

      expect(output).to include('Subscription cost for Netflix updated to $24.99 successfully.')
      expect(output).to match(/Netflix\s+\$24\.99/)
      expect(output).not_to include('$19.99')
    end

    it 'applies the same cost validation as add' do
      output = run_subtrack(*add_input('Netflix', '19.99'), 'update', 'Netflix', '0', 'list', 'quit')

      expect(output).to include('Cost must be a positive number')
      expect(output).not_to include('updated to')
      expect(output).to match(/Netflix\s+\$19\.99/)
    end

    it 'reports a subscription that does not exist' do
      output = run_subtrack('update', 'Hulu', '5', 'quit')
      expect(output).to include('Subscription named Hulu not found in subscription list.')
    end

    it 'reports a missing name before asking for the new cost' do
      output = run_subtrack('update', 'Hulu', 'quit')

      expect(output).to include('Subscription named Hulu not found in subscription list.')
      expect(output).not_to include('Enter subscription cost')
    end

    it 'finds the subscription ignoring case and shows its stored name' do
      output = run_subtrack(*add_input('Netflix', '19.99'), 'update', 'NETFLIX', '24.99', 'list', 'quit')

      expect(output).to include('Subscription cost for Netflix updated to $24.99 successfully.')
      expect(output).to match(/Netflix\s+\$24\.99/)
    end
  end

  describe 'delete' do
    it 'removes a subscription after confirmation' do
      output = run_subtrack(*add_input('Netflix', '24.99'), 'delete', 'Netflix', 'y', 'list', 'quit')

      expect(output).to include('Subscription Netflix deleted successfully.')
      expect(output).to include('Subscription list empty.')
    end

    it 'finds the subscription ignoring case and shows its stored name' do
      output = run_subtrack(*add_input('Netflix', '24.99'), 'delete', 'netflix', 'y', 'list', 'quit')

      expect(output).to include("Delete subscription named 'Netflix'?")
      expect(output).to include('Subscription Netflix deleted successfully.')
      expect(output).to include('Subscription list empty.')
    end

    it 'reports a missing name without asking for confirmation' do
      output = run_subtrack('delete', 'Hulu', 'quit')

      expect(output).to include('Subscription named Hulu not found in subscription list.')
      expect(output).not_to include('Enter \'y\' or \'yes\' to confirm')
    end

    it 'keeps the subscription when deletion is not confirmed' do
      output = run_subtrack(*add_input('Netflix', '24.99'), 'delete', 'Netflix', 'n', 'list', 'quit')

      expect(output).to include('Deletion canceled.')
      expect(output).to match(/Netflix\s+\$24\.99/)
    end

    it 'reports a subscription that does not exist' do
      output = run_subtrack('delete', 'Hulu', 'yes', 'quit')
      expect(output).to include('Subscription named Hulu not found in subscription list.')
    end
  end

  describe 'update then delete (proposal test 3)' do
    it 'shows the new price, then the subscription is gone' do
      output = run_subtrack(
        *add_input('Netflix', '19.99'),
        'update', 'Netflix', '24.99', 'list',
        'delete', 'Netflix', 'y', 'list', 'quit'
      )

      expect(output).to match(/Netflix\s+\$24\.99/)
      expect(output).to include('Subscription list empty.')
    end
  end

  describe 'save and load)' do
    it 'keeps a subscription after the app is closed and reopened' do
      run_subtrack(*add_input('Netflix', '24.99', category: 'Streaming'), 'save', 'quit')
      output = run_subtrack('load', 'list', 'quit')

      expect(output).to match(/Netflix\s+\$24\.99\s+month\s+Streaming\s+2026-10-01/)
    end

    it 'creates the data folder on first save' do
      run_subtrack(*add_input('Netflix', '24.99'), 'save', 'quit')
      expect(File.exist?(File.join(@project_dir, 'data', 'saved_list.json'))).to be(true)
    end

    it 'reports when there is no saved list to load' do
      output = run_subtrack('load', 'quit')
      expect(output).to include('No saved subscription list found.')
    end

    it 'saves changes made after loading' do
      run_subtrack(*add_input('Netflix', '19.99'), *add_input('Spotify', '10'), 'save', 'quit')
      run_subtrack('load', 'update', 'Netflix', '24.99', 'delete', 'Spotify', 'y', 'save', 'quit')
      output = run_subtrack('load', 'list', 'quit')

      expect(output).to match(/Netflix\s+\$24\.99/)
      expect(output).not_to include('Spotify')
    end
  end

  describe 'search (US-2, proposal test 2)' do
    it 'shows the details of a matching subscription, then reports a missing one' do
      output = run_subtrack(
        *add_input('Netflix', '24.99', category: 'Streaming'),
        *add_input('Spotify', '10', category: 'Music'),
        'search', 'Netflix',
        'search', 'Hulu', 'quit'
      )

      expect(output).to include("Search results for 'Netflix':")
      expect(output).to match(/Netflix\s+\$24\.99\s+month\s+Streaming\s+2026-10-01/)
      expect(output).to include('Subscription not found.')
    end

    it 'ignores case and matches part of a name' do
      output = run_subtrack(*add_input('Netflix', '24.99'), *add_input('Spotify', '10'), 'search', 'NET', 'quit')

      expect(output).to match(/Netflix\s+\$24\.99/)
      expect(output).not_to match(/Spotify\s+\$10\.00/)
    end

    it 'rejects an empty search' do
      output = run_subtrack('search', '', 'quit')
      expect(output).to include('Search cannot be empty')
    end

    it 'no longer finds a deleted subscription' do
      output = run_subtrack(*add_input('Netflix', '24.99'), 'delete', 'Netflix', 'y', 'search', 'Netflix', 'quit')
      expect(output).to include('Subscription not found.')
    end
  end

  describe 'filter (US-2)' do
    it 'shows every subscription in the category and nothing else' do
      output = run_subtrack(
        *add_input('Netflix', '24.99', category: 'Streaming'),
        *add_input('Hulu', '7.99', category: 'Streaming'),
        *add_input('Spotify', '10', category: 'Music'),
        'filter', 'streaming', 'quit'
      )

      expect(output).to include("Subscriptions in category 'streaming':")
      expect(output).to match(/Netflix\s+\$24\.99\s+month\s+Streaming/)
      expect(output).to match(/Hulu\s+\$7\.99\s+month\s+Streaming/)
      expect(output).not_to match(/Spotify\s+\$10\.00/)
    end

    it 'finds subscriptions with no category using N/A' do
      output = run_subtrack(*add_input('Gym', '30'), *add_input('Spotify', '10', category: 'Music'), 'filter', 'N/A', 'quit')

      expect(output).to match(/Gym\s+\$30\.00\s+month\s+N\/A/)
      expect(output).not_to match(/Spotify\s+\$10\.00/)
    end

    it 'reports a category with no subscriptions' do
      output = run_subtrack(*add_input('Netflix', '24.99', category: 'Streaming'), 'filter', 'Software', 'quit')
      expect(output).to include("No subscriptions found in category 'Software'.")
    end

    it 'rejects an empty category' do
      output = run_subtrack('filter', '', 'quit')
      expect(output).to include('Category cannot be empty')
    end
  end

  describe 'help and general commands (US-8)' do
    it 'lists every command' do
      output = run_subtrack('help', 'quit')
      %w[add list search filter summary update delete save load quit].each do |command|
        expect(output).to include("'#{command}'")
      end
    end

    it 'reports unknown commands' do
      output = run_subtrack('foo', 'quit')
      expect(output).to include("Unknown command 'foo'. Type 'h' for help.")
    end

    it 'exits on quit' do
      output = run_subtrack('quit')
      expect(output).to include('Thank you for using SubTrack!')
    end

    it 'exits cleanly when input ends without quit' do
      output = run_subtrack('list')
      expect(output).to include('Subscription list empty.')
    end
  end

  describe 'summary (US-6, proposal test 4)' do
    it 'shows $40 per month and $480 per year for the proposal example' do
      output = run_subtrack(
        *add_input('Netflix', '20'),
        *add_input('Spotify', '10'),
        *add_input('Amazon Prime', '120', frequency: 'year'),
        'summary', 'quit'
      )

      expect(output).to include('Estimated monthly cost: $40.00')
      expect(output).to include('Estimated yearly cost:  $480.00')
    end

    it 'reflects updates and deletions' do
      output = run_subtrack(
        *add_input('Netflix', '20'),
        *add_input('Spotify', '10'),
        'update', 'Netflix', '15',
        'delete', 'Spotify', 'y',
        'summary', 'quit'
      )

      expect(output).to include('Estimated monthly cost: $15.00')
      expect(output).to include('Estimated yearly cost:  $180.00')
    end

    it 'shows the totals of a loaded list' do
      run_subtrack(*add_input('Amazon Prime', '120', frequency: 'year'), 'save', 'quit')
      output = run_subtrack('load', 'summary', 'quit')

      expect(output).to include('Estimated monthly cost: $10.00')
      expect(output).to include('Estimated yearly cost:  $120.00')
    end

    it 'reports an empty list instead of $0.00 totals' do
      output = run_subtrack('summary', 'quit')

      expect(output).to include('Subscription list empty.')
      expect(output).not_to include('Estimated')
    end
  end
end
