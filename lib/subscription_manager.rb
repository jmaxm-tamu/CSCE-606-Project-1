require_relative 'subscription'

class SubscriptionManager
  def initialize
    @subscription_list = []
  end

  attr_reader :subscription_list

  def add_subscription(name, cost, cat_arg: '', freq_arg: 'month', renew_arg: Date.new(2000-01-01))
    # checks 
    sub = Subscription.new(name, cost, cat_arg: cat_arg, freq_arg: freq_arg, renew_arg: renew_arg)

    @subscription_list << sub
  end

  def list_subscriptions
    # Basic functionality, clean up later
    puts 'Subscription list empty.' if @subscription_list.empty?
    puts 'Displaying subscription list:' if !@subscription_list.empty?
    subscription_list.each do |sub_item|
      # Display 'N/A' for category if empty
      cat_name = sub_item.category == '' ? 'N/A' : sub_item.category
      puts '%s -- $%.2f -- %s -- %s -- %s' % [sub_item.name, sub_item.cost, cat_name, sub_item.frequency, sub_item.renewal.to_s]
    end
  end
end