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

  # Function checks current directory to determine filepath for saving and loading data. 
  # (Assumes user is in correct 'CSCE-606-Project-1' or 'lib' directory to determine correct relative path, otherwise returns empty.)
  # (Therefore assumes user is running program from correct folder as expected.)
  def check_dir
    curr_path = Dir.pwd
    if curr_path.end_with?('CSCE-606-Project-1')
      file_path = './data/saved_list.json'
    elsif curr_path.end_with?('CSCE-606-Project-1/lib') || curr_path.end_with?('CSCE-606-Project-1\lib')
      file_path = '../data/saved_list.json'
    else 
      return ''
    end
    return file_path
  end 

  def save_list
    file_path = check_dir

    # If pwd not valid, handled in subtrack
    return 1 if file_path == ''

    sub_list = @subscription_manager.subscription_list
    File.write(file_path, sub_list.to_json)
    return 0
  end

  def load_list
    file_path = check_dir

    # If pwd not valid, handled in subtrack
    return 1 if file_path == ''

    sub_list = JSON.load_file(file_path, symbolize_names: true)
    subscription_manager_load = SubscriptionManager.new

    # for each subscription in JSON file, create subscription in SubscriptionManager
    sub_list.each do |sub|
      subscription_manager_load.add_subscription(sub[:name], sub[:cost], cat_arg: sub[:category], freq_arg: sub[:frequency], renew_arg: sub[:renewal])
    end

    # replace initialized SubscriptionManager
    @subscription_manager = subscription_manager_load
    return 0
  end
end