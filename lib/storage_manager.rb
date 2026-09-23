require_relative 'subscription_manager'

class StorageManager
  def initialize
    @subscription_manager = SubscriptionManager.new

    # if saved list exists, load that list
  end

  attr_reader :subscription_manager

=begin
  # obsolete method
  def standardize_list
    standardized_list = []
    @subscription_manager.subscription_list.each do |sub|
      sub_item = [sub.name, sub.cost]
      standardized_list << sub_item
    end
    standardized_list
  end
=end

  def save_list
    sub_list = @subscription_manager.subscription_list
    File.write('./data/saved_list.json', sub_list.to_json)
  end

  def load_list
    sub_list = JSON.load_file('./data/saved_list.json', symbolize_names: true)
    subscription_manager_load = SubscriptionManager.new

    # for each subscription in JSON file, create subscription in SubscriptionManager
    sub_list.each do |sub|
      subscription_manager_load.add_subscription(sub[:name], sub[:cost], cat_arg: sub[:category], freq_arg: sub[:frequency], renew_arg: sub[:renewal])
    end

    # replace initialized SubscriptionManager
    @subscription_manager = subscription_manager_load
  end
end