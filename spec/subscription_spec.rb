require_relative '../lib/subscription'

describe 'Subscription' do
  it 'should be defined' do
    expect { Subscription }.not_to raise_error
  end

  describe '#initialize' do
    it 'stores all fields' do
      sub = Subscription.new('Netflix', 24.99, cat_arg: 'Streaming', freq_arg: 'year', renew_arg: Date.new(2026, 10, 1))

      expect(sub.name).to eq('Netflix')
      expect(sub.cost).to eq(24.99)
      expect(sub.category).to eq('Streaming')
      expect(sub.frequency).to eq('year')
      expect(sub.renewal).to eq(Date.new(2026, 10, 1))
    end

    it 'uses defaults for optional fields' do
      sub = Subscription.new('Netflix', 24.99)

      expect(sub.category).to eq('')
      expect(sub.frequency).to eq('month')
      expect(sub.renewal).to eq(Date.new(2000, 1, 1))
    end

    it 'rejects an empty name' do
      expect { Subscription.new('', 24.99) }.to raise_error(ArgumentError, 'Subscription name cannot be empty')
    end

    it 'rejects a zero cost' do
      expect { Subscription.new('Netflix', 0) }.to raise_error(ArgumentError, 'Cost of subscription must be positive')
    end

    it 'rejects a negative cost' do
      expect { Subscription.new('Netflix', -5) }.to raise_error(ArgumentError, 'Cost of subscription must be positive')
    end

    it 'rejects a frequency other than month or year' do
      expect { Subscription.new('Netflix', 24.99, freq_arg: 'week') }.to raise_error(ArgumentError, 'Frequency must be monthly or yearly')
    end
  end

  describe '#cost=' do
    let(:sub) { Subscription.new('Netflix', 19.99) }

    it 'updates the cost' do
      sub.cost = 24.99
      expect(sub.cost).to eq(24.99)
    end

    it 'rejects a zero or negative cost and keeps the old one' do
      expect { sub.cost = 0 }.to raise_error(ArgumentError, 'Cost of subscription must be positive')
      expect { sub.cost = -1 }.to raise_error(ArgumentError)
      expect(sub.cost).to eq(19.99)
    end
  end

  describe '#yearly_cost' do
    it 'multiplies a monthly cost by 12' do
      expect(Subscription.new('Netflix', 20, freq_arg: 'month').yearly_cost).to eq(240)
    end

    it 'returns a yearly cost unchanged' do
      expect(Subscription.new('Amazon Prime', 120, freq_arg: 'year').yearly_cost).to eq(120)
    end

    it 'reflects an updated cost' do
      sub = Subscription.new('Netflix', 20)
      sub.cost = 10
      expect(sub.yearly_cost).to eq(120)
    end
  end

  describe '#to_hash' do
    it 'contains every field' do
      sub = Subscription.new('Netflix', 24.99, cat_arg: 'Streaming', renew_arg: Date.new(2026, 10, 1))

      expect(sub.to_hash).to eq(
        name: 'Netflix',
        cost: 24.99,
        category: 'Streaming',
        frequency: 'month',
        renewal: Date.new(2026, 10, 1)
      )
    end
  end

  describe '#to_json' do
    it 'serializes every field, with the renewal date as YYYY-MM-DD' do
      sub = Subscription.new('Netflix', 24.99, cat_arg: 'Streaming', renew_arg: Date.new(2026, 10, 1))

      expect(JSON.parse(sub.to_json)).to eq(
        'name' => 'Netflix',
        'cost' => 24.99,
        'category' => 'Streaming',
        'frequency' => 'month',
        'renewal' => '2026-10-01'
      )
    end

    it 'serializes a list of subscriptions as a JSON array' do
      subs = [Subscription.new('Netflix', 24.99), Subscription.new('Spotify', 10)]
      expect(JSON.parse(subs.to_json).map { |h| h['name'] }).to eq(['Netflix', 'Spotify'])
    end
  end
end
