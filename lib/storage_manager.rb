require_relative 'subscription_manager'
require 'fileutils'

class StorageManager
  def initialize
    @subscription_manager = SubscriptionManager.new

    # TODO (US-7): if saved list exists, load that list
  end

  attr_reader :subscription_manager

  # Names skipped by the last load_list because they were already in the file
  attr_reader :skipped_duplicates

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
    FileUtils.mkdir_p(File.dirname(file_path))
    File.write(file_path, sub_list.to_json)
    return 0
  end

  def load_list
    file_path = check_dir

    # If pwd not valid, handled in subtrack
    return 1 if file_path == ''

    # No saved list yet, handled in subtrack
    return 2 if !File.exist?(file_path)

    sub_list = JSON.load_file(file_path, symbolize_names: true)
    subscription_manager_load = SubscriptionManager.new
    @skipped_duplicates = []

    # for each subscription in JSON file, create subscription in SubscriptionManager
    sub_list.each do |sub|
      # Skip names already loaded (e.g. a file saved before names had to be unique)
      if subscription_manager_load.subscription_exists?(sub[:name])
        @skipped_duplicates << sub[:name]
        next
      end

      subscription_manager_load.add_subscription(sub[:name], sub[:cost], cat_arg: sub[:category], freq_arg: sub[:frequency], renew_arg: Date.parse(sub[:renewal]))
    end

    # replace initialized SubscriptionManager
    @subscription_manager = subscription_manager_load
    return 0
  end
end