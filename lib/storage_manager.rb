require_relative 'subscription_manager'
require 'json'

class StorageManager
  def initialize
    @subscription_manager = SubscriptionManager.new

    # if saved list exists, load that list
  end

  def standardize_list
    standardized_list = []
    @subscription_manager.subscription_list.each do |sub|
      sub_item = [sub.name, sub.cost]
      standardized_list << sub_item
    end
    standardized_list
  end

  def save_list
    sub_list = standardize_list
    File.write('../data/saved_list.json', sub_list.to_json)
  end

  def load_list
    sub_list = JSON.parse_file('../data/saved_list.json')
    subscription_manager_load = SubscriptionManager.new

    sub_list.each do |sub|
      subscription_manager_load.add_subscription(name, cost)
    end
  end
end