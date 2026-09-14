require_relative 'subscription'

class SubscriptionManager
  def initialize
    @subscription_list = []
  end

  attr_reader :subscription_list

  def add_subscription(name, cost)
    # checks here or in subscription?
    sub = Subscription.new(name, cost)

    @subscription_list << sub
  end

  def list_subscriptions
    # Basic functionality, clean up later
    puts 'Subscription list empty.' if @subscription_list.empty?
    puts 'Displaying subscription list:' if !@subscription_list.empty?
    subscription_list.each do |sub_item|
      puts sub_item.name
      puts sub_item.cost
    end
  end
end