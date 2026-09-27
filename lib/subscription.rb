# Date used for renewal date operations, BigDecimal used for cost checks
require 'date'
require 'bigdecimal'
require 'json'

class Subscription
  # Need to add billing frequency (month vs year), category, and renewal 
  def initialize(name_arg, cost_arg, cat_arg: '', freq_arg: 'month', renew_arg: Date.new(2000-01-01))
    @name = name_arg
    @cost = cost_arg
    @category = cat_arg
    @frequency = freq_arg
    @renewal = renew_arg

    init_validate
  end

  def init_validate 
    # Check validity of all inputs

    if name == ''
      raise ArgumentError, 'Subscription name cannot be empty'
    elsif cost <= 0
      raise ArgumentError, 'Cost of subscription must be positive'
    elsif frequency != 'month' && frequency != 'year'
      raise ArgumentError, 'Frequency must be monthly or yearly'
    # elsif renewal -- add later for date 
    end
  end

  attr_reader :name
  attr_reader :cost
  attr_reader :category
  attr_reader :frequency
  attr_reader :renewal

  def cost=(new_cost)
    if new_cost <= 0
      raise ArgumentError, 'Cost of subscription must be positive'
    else 
      @cost = new_cost
    end
  end

  def yearly_cost
    if frequency == 'month'
      return cost * 12
    else
      return cost
    end
  end

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