require_relative '../lib/subscription_manager'

describe 'SubscriptionManager#format_subscription_list' do
  let(:manager) { SubscriptionManager.new }

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

  it 'aligns columns' do
    manager.add_subscription('Netflix', 24.99, renew_arg: Date.new(2026, 10, 1))
    manager.add_subscription('HBO', 5.0, renew_arg: Date.new(2026, 11, 1))

    rows = manager.format_subscription_list.lines.drop(3)
    expect(rows[0].index('$')).to eq(rows[1].index('$'))
  end
end
