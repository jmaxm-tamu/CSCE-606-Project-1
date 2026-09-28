require_relative '../lib/subscription_manager'

describe 'SubscriptionManager' do
  let(:manager) { SubscriptionManager.new }

  describe '#initialize' do
    it 'starts with an empty list and zero yearly cost' do
      expect(manager.subscription_list).to be_empty
      expect(manager.year_cost).to eq(0.0)
    end
  end

  describe '#add_subscription' do
    it 'adds a subscription with all fields' do
      manager.add_subscription('Netflix', 24.99, cat_arg: 'Streaming', freq_arg: 'year', renew_arg: Date.new(2026, 10, 1))

      sub = manager.subscription_list.first
      expect(manager.subscription_list.size).to eq(1)
      expect(sub.name).to eq('Netflix')
      expect(sub.cost).to eq(24.99)
      expect(sub.category).to eq('Streaming')
      expect(sub.frequency).to eq('year')
      expect(sub.renewal).to eq(Date.new(2026, 10, 1))
    end

    it 'keeps subscriptions in the order they were added' do
      manager.add_subscription('Netflix', 24.99)
      manager.add_subscription('Spotify', 10)

      expect(manager.subscription_list.map(&:name)).to eq(['Netflix', 'Spotify'])
    end

    it 'adds each subscription to the yearly cost' do
      manager.add_subscription('Netflix', 20, freq_arg: 'month')
      manager.add_subscription('Amazon Prime', 120, freq_arg: 'year')

      expect(manager.year_cost).to be_within(0.001).of(360)
    end

    it 'totals $480 per year for the proposal example (proposal test 4)' do
      manager.add_subscription('Netflix', 20, freq_arg: 'month')
      manager.add_subscription('Spotify', 10, freq_arg: 'month')
      manager.add_subscription('Amazon Prime', 120, freq_arg: 'year')

      expect(manager.year_cost).to be_within(0.001).of(480)
    end

    it 'raises on invalid input and leaves the list and yearly cost unchanged' do
      manager.add_subscription('Netflix', 20)

      expect { manager.add_subscription('', 10) }.to raise_error(ArgumentError)
      expect { manager.add_subscription('Spotify', -10) }.to raise_error(ArgumentError)
      expect { manager.add_subscription('Spotify', 10, freq_arg: 'week') }.to raise_error(ArgumentError)

      expect(manager.subscription_list.map(&:name)).to eq(['Netflix'])
      expect(manager.year_cost).to be_within(0.001).of(240)
    end
  end

  describe '#month_cost' do
    it 'is zero with no subscriptions' do
      expect(manager.month_cost).to eq(0)
    end

    it 'gives $40 per month for the proposal example (proposal test 4)' do
      manager.add_subscription('Netflix', 20, freq_arg: 'month')
      manager.add_subscription('Spotify', 10, freq_arg: 'month')
      manager.add_subscription('Amazon Prime', 120, freq_arg: 'year')

      expect(manager.month_cost).to be_within(0.001).of(40)
    end

    it 'spreads a yearly plan over 12 months' do
      manager.add_subscription('Amazon Prime', 139, freq_arg: 'year')
      expect(manager.month_cost).to be_within(0.001).of(139.0 / 12)
    end

    it 'follows updates and deletions' do
      manager.add_subscription('Netflix', 20)
      manager.add_subscription('Spotify', 10)
      manager.update_subscription('Netflix', 15)
      manager.delete_subscription('Spotify')

      expect(manager.month_cost).to be_within(0.001).of(15)
    end
  end

  describe '#delete_subscription' do
    before do
      manager.add_subscription('Netflix', 20, freq_arg: 'month')
      manager.add_subscription('Amazon Prime', 120, freq_arg: 'year')
    end

    it 'removes the named subscription and returns 0' do
      expect(manager.delete_subscription('Netflix')).to eq(0)
      expect(manager.subscription_list.map(&:name)).to eq(['Amazon Prime'])
    end

    it 'subtracts the deleted subscription from the yearly cost' do
      manager.delete_subscription('Netflix')
      expect(manager.year_cost).to be_within(0.001).of(120)
    end

    it 'returns 1 and changes nothing when the name is not found' do
      expect(manager.delete_subscription('Hulu')).to eq(1)
      expect(manager.subscription_list.size).to eq(2)
      expect(manager.year_cost).to be_within(0.001).of(360)
    end

    it 'ignores case' do
      expect(manager.delete_subscription('netflix')).to eq(0)
      expect(manager.subscription_list.map(&:name)).to eq(['Amazon Prime'])
    end

    it 'only removes the subscription with the full name' do
      manager.add_subscription('Netflix Premium', 30)
      manager.delete_subscription('Netflix')

      expect(manager.subscription_list.map(&:name)).to eq(['Amazon Prime', 'Netflix Premium'])
    end
  end

  describe 'duplicate names (US-9)' do
    before { manager.add_subscription('Netflix', 20) }

    it 'rejects a name that already exists' do
      expect { manager.add_subscription('Netflix', 30) }
        .to raise_error(ArgumentError, "A subscription named 'Netflix' already exists")
    end

    it 'rejects a name that differs only in case' do
      expect { manager.add_subscription('NETFLIX', 30) }.to raise_error(ArgumentError)
    end

    it 'leaves the list and yearly cost unchanged after a rejected duplicate' do
      expect { manager.add_subscription('netflix', 30) }.to raise_error(ArgumentError)

      expect(manager.subscription_list.map(&:name)).to eq(['Netflix'])
      expect(manager.year_cost).to be_within(0.001).of(240)
    end

    it 'allows a name that only contains an existing name' do
      manager.add_subscription('Netflix Premium', 30)
      expect(manager.subscription_list.map(&:name)).to eq(['Netflix', 'Netflix Premium'])
    end
  end

  describe '#find_subscription' do
    before do
      manager.add_subscription('Netflix', 20)
      manager.add_subscription('Netflix Premium', 30)
    end

    it 'finds a subscription by its full name, ignoring case' do
      expect(manager.find_subscription('NETFLIX').name).to eq('Netflix')
      expect(manager.find_subscription('netflix premium').name).to eq('Netflix Premium')
    end

    it 'does not match part of a name' do
      expect(manager.find_subscription('Net')).to be_nil
    end

    it 'returns nil when the name is not found' do
      expect(manager.find_subscription('Hulu')).to be_nil
    end
  end

  describe '#subscription_exists?' do
    it 'is true for an existing name in any case and false otherwise' do
      manager.add_subscription('Netflix', 20)

      expect(manager.subscription_exists?('netflix')).to be(true)
      expect(manager.subscription_exists?('Hulu')).to be(false)
    end
  end

  describe '#update_subscription' do
    before do
      manager.add_subscription('Netflix', 19.99, freq_arg: 'month')
      manager.add_subscription('Amazon Prime', 120, freq_arg: 'year')
    end

    it 'changes the cost of the named subscription and returns 0' do
      expect(manager.update_subscription('Netflix', 24.99)).to eq(0)
      expect(manager.subscription_list.first.cost).to eq(24.99)
    end

    it 'updates the yearly cost to match' do
      manager.update_subscription('Netflix', 10)
      expect(manager.year_cost).to be_within(0.001).of(240)
    end

    it 'returns 1 and changes nothing when the name is not found' do
      expect(manager.update_subscription('Hulu', 5)).to eq(1)
      expect(manager.subscription_list.map(&:cost)).to eq([19.99, 120])
    end

    it 'ignores case' do
      expect(manager.update_subscription('NETFLIX', 24.99)).to eq(0)
      expect(manager.subscription_list.first.cost).to eq(24.99)
    end

    it 'keeps the old cost and yearly cost when the new cost is invalid' do
      expect { manager.update_subscription('Netflix', 0) }.to output(/Cost of subscription must be positive/).to_stdout

      expect(manager.subscription_list.first.cost).to eq(19.99)
      expect(manager.year_cost).to be_within(0.001).of(19.99 * 12 + 120)
    end
  end

  describe '#search_subscriptions' do
    before do
      manager.add_subscription('Netflix', 20, cat_arg: 'Streaming')
      manager.add_subscription('Spotify', 10, cat_arg: 'Music')
      manager.add_subscription('Netflix Games', 5, cat_arg: 'Gaming')
    end

    it 'finds a subscription by its exact name' do
      expect(manager.search_subscriptions('Spotify').map(&:name)).to eq(['Spotify'])
    end

    it 'ignores case' do
      expect(manager.search_subscriptions('spotify').map(&:name)).to eq(['Spotify'])
    end

    it 'matches part of a name and returns every match' do
      expect(manager.search_subscriptions('net').map(&:name)).to eq(['Netflix', 'Netflix Games'])
    end

    it 'returns an empty list when nothing matches' do
      expect(manager.search_subscriptions('Hulu')).to be_empty
    end

    it 'does not change the subscription list' do
      manager.search_subscriptions('Netflix')
      expect(manager.subscription_list.size).to eq(3)
    end
  end

  describe '#filter_by_category' do
    before do
      manager.add_subscription('Netflix', 20, cat_arg: 'Streaming')
      manager.add_subscription('Hulu', 8, cat_arg: 'Streaming')
      manager.add_subscription('Spotify', 10, cat_arg: 'Music')
      manager.add_subscription('Gym', 30)
    end

    it 'returns every subscription in the category' do
      expect(manager.filter_by_category('Streaming').map(&:name)).to eq(['Netflix', 'Hulu'])
    end

    it 'ignores case' do
      expect(manager.filter_by_category('music').map(&:name)).to eq(['Spotify'])
    end

    it 'matches the whole category, not part of it' do
      expect(manager.filter_by_category('Stream')).to be_empty
    end

    it 'finds subscriptions with no category using N/A' do
      expect(manager.filter_by_category('n/a').map(&:name)).to eq(['Gym'])
    end

    it 'returns an empty list for an unknown category' do
      expect(manager.filter_by_category('Software')).to be_empty
    end
  end

  describe '#format_table' do
    it 'formats only the given subscriptions, without the list heading' do
      manager.add_subscription('Netflix', 20, renew_arg: Date.new(2026, 10, 1))
      manager.add_subscription('Spotify', 10)

      output = manager.format_table(manager.search_subscriptions('Netflix'))
      expect(output.lines.first).to match(/^Name\s+Cost/)
      expect(output).to match(/Netflix\s+\$20\.00\s+month\s+N\/A\s+2026-10-01/)
      expect(output).not_to include('Spotify', 'Displaying')
    end
  end

  describe '#list_subscriptions' do
    it 'prints the formatted list' do
      manager.add_subscription('Netflix', 24.99, renew_arg: Date.new(2026, 10, 1))
      expect { manager.list_subscriptions }.to output(/Netflix\s+\$24\.99/).to_stdout
    end

    it 'prints the empty message when there are no subscriptions' do
      expect { manager.list_subscriptions }.to output("Subscription list empty.\n").to_stdout
    end
  end

  describe '#format_subscription_list' do
    it 'reports an empty list clearly' do
      expect(manager.format_subscription_list).to eq('Subscription list empty.')
    end

    it 'shows every subscription with name, cost, frequency, category, and renewal' do
      manager.add_subscription('Netflix', 24.99, cat_arg: 'Streaming', freq_arg: 'month', renew_arg: Date.new(2026, 10, 1))
      manager.add_subscription('iCloud', 9.9, freq_arg: 'year', renew_arg: Date.new(2027, 1, 15))

      output = manager.format_subscription_list
      expect(output).to include('Name', 'Cost', 'Frequency', 'Category', 'Renewal')
      expect(output).to match(/Netflix\s+\$24\.99\s+month\s+Streaming\s+2026-10-01/)
      expect(output).to match(/iCloud\s+\$9\.90\s+year\s+N\/A\s+2027-01-15/)
    end

    it 'shows N/A for a missing category' do
      manager.add_subscription('Netflix', 24.99, cat_arg: nil)
      expect(manager.format_subscription_list).to match(/Netflix\s+\$24\.99\s+month\s+N\/A/)
    end

    it 'aligns columns' do
      manager.add_subscription('Netflix', 24.99, renew_arg: Date.new(2026, 10, 1))
      manager.add_subscription('HBO', 5.0, renew_arg: Date.new(2026, 11, 1))

      rows = manager.format_subscription_list.lines.drop(3)
      expect(rows[0].index('$')).to eq(rows[1].index('$'))
    end

    it 'reflects updates and deletions' do
      manager.add_subscription('Netflix', 19.99)
      manager.add_subscription('Spotify', 10)
      manager.update_subscription('Netflix', 24.99)
      manager.delete_subscription('Spotify')

      output = manager.format_subscription_list
      expect(output).to include('$24.99')
      expect(output).not_to include('$19.99', 'Spotify')
    end
  end
end
