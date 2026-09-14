require_relative 'subscription'

class SubscriptionManager
  def initialize
    @subscription_list = []
  end

  attr_reader :subscription_list

  def add_subscription(name, cost)
  end

  def list_subscriptions
  end
end