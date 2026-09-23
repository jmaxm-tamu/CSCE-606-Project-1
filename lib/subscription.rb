# Date used for renewal date operations, BigDecimal used for cost checks
require 'date'
require 'bigdecimal'
require 'json'

class Subscription
  # Need to add billing frequency (month vs year), category, and renewal 
  def initialize(name_arg, cost_arg, cat_arg: '', freq_arg: 'month', renew_arg: Date.new(2000-01-01))
    # Check validity of all inputs
=begin
    if name_arg == ''
      raise ArgumentError, 'Subscription name cannot be empty'
    elsif cost_arg <= 0
      raise ArgumentError, 'Cost of subscription must be positive'
    elsif freq_arg != 'month' && freq_arg != 'year'
      raise ArgumentError, 'Frequency must be monthly or yearly'
    # elsif renew_arg -- add later for date 
    end
=end
    @name = name_arg
    @cost = cost_arg
    @category = cat_arg
    @frequency = freq_arg
    @renewal = renew_arg
  end

  attr_reader :name
  attr_reader :cost
  attr_reader :category
  attr_reader :frequency
  attr_reader :renewal

  def to_hash
    {
      name: @name,
      cost: @cost,
      category: @category,
      frequency: @frequency,
      renewal: @renewal
    }
  end

  def to_json(*options)
    to_hash.to_json(*options)
  end
end