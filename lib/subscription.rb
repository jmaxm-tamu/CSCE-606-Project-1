class Subscription
  def initialize(name_arg, cost_arg)
    @name = name_arg
    @cost = cost_arg
  end

  attr_reader :name
  attr_reader :cost
end