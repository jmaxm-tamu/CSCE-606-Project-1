require_relative 'storage_manager'

# Methods
def subtrack_init
  info
  @storage_manager = StorageManager.new
end

def info 
  puts 'Welcome to Subtrack!'
  puts 'This is a system for cataloguing, tracking, and saving your current subscriptions.'
  puts 'Type \'h\' for help.'
end

def help
  puts 'To add a subscription, type \'add\'.'
  puts 'To list currently saved subscriptions, type \'list\'.'
  puts 'To search for a subscription by name, type \'search\'.'
  puts 'To show subscriptions in one category, type \'filter\'.'
  puts 'To see your estimated monthly and yearly costs, type \'summary\'.'
  puts 'To change the cost of a subscription, type \'update\'.'
  puts 'To remove a subscription, type \'delete\'.'
  puts 'To save your subscription list to file, type \'save\'.'
  puts 'To load your saved subscription list, type \'load\'.'
  puts 'To exit SubTrack, type \'quit\'.'
end

def add
  puts 'To add a new subscription, enter the name, billing cost,'
  puts 'billing frequency, category (optional), and renewal date.'

  # Subscription name and check
  puts 'Enter subscription name:'
  name = gets.chomp.strip
  if name == ''
    puts 'Name cannot be empty'
    return
  end

  # Names must be unique (ignoring case), so check before asking for the other fields
  existing = @storage_manager.subscription_manager.find_subscription(name)
  if existing
    puts "A subscription named '#{existing.name}' already exists. Use 'update' to change it."
    return
  end

  # Cost and check
  puts 'Enter subscription cost (dollars and cents):'
  cost = gets.chomp.strip
  if !cost_check(cost)
    puts 'Cost must be a positive number and cannot have more than two decimal places'
    return
  end

  # Subscription category
  puts 'Enter subscription category (or leave blank):'
  category = gets.chomp.strip

  # Billing frequency and check
  puts 'Enter billing frequency (\'month\' or \'year\'):'
  frequency = gets.chomp.strip
  if frequency != 'month' && frequency != 'year'
    puts 'Billing frequency must be monthly or yearly'
    return
  end

  # Renewal date and check
  puts 'Enter next renewal date (YYYY-MM-DD format):'
  renewal = gets.chomp.strip
  if !date_check(renewal)
    puts 'Renewal date must be in YYYY-MM-DD format'
    return
  end

  # Run "add" method from subscription_manager.rb
  @storage_manager.subscription_manager.add_subscription(name, cost.to_f, cat_arg: category, freq_arg: frequency, renew_arg: Date.parse(renewal))
  puts "Subscription #{name} added successfully."
end

# Checks if cost is a positive number with at most two decimal points
def cost_check(cost)
  BigDecimal(cost) > 0 && BigDecimal(cost) == BigDecimal(cost).ceil(2)
rescue ArgumentError
  false
end

# Checks if date is in YYYY-MM-DD format
def date_check(date)
  Date.xmlschema(date)
  true
rescue ArgumentError
  false
end

def list
  @storage_manager.subscription_manager.list_subscriptions
end

def search
  puts 'Enter subscription name (or part of it) to search for:'
  query = gets.chomp.strip
  if query == ''
    puts 'Search cannot be empty'
    return
  end

  manager = @storage_manager.subscription_manager
  results = manager.search_subscriptions(query)
  if results.empty?
    puts 'Subscription not found.'
  else
    puts "Search results for '#{query}':"
    puts manager.format_table(results)
  end
end

def summary
  manager = @storage_manager.subscription_manager
  if manager.subscription_list.empty?
    puts 'Subscription list empty.'
    return
  end

  puts "Estimated monthly cost: $%.2f" % manager.month_cost
  puts "Estimated yearly cost:  $%.2f" % manager.year_cost
end

def filter
  puts 'Enter category to filter by (\'N/A\' for subscriptions with no category):'
  category = gets.chomp.strip
  if category == ''
    puts 'Category cannot be empty'
    return
  end

  manager = @storage_manager.subscription_manager
  results = manager.filter_by_category(category)
  if results.empty?
    puts "No subscriptions found in category '#{category}'."
  else
    puts "Subscriptions in category '#{category}':"
    puts manager.format_table(results)
  end
end


def update
  puts 'Enter name of subscription to update and new cost.'

  # Subscription name and check
  puts 'Enter subscription name:'
  name = gets.chomp.strip
  if name == ''
    puts 'Name cannot be empty'
    return
  end

  # Find the subscription first (ignoring case) so a missing name is reported right away
  sub = @storage_manager.subscription_manager.find_subscription(name)
  if sub.nil?
    puts "Subscription named #{name} not found in subscription list."
    return
  end

  # Cost and check
  puts 'Enter subscription cost (dollars and cents):'
  cost = gets.chomp.strip
  if !cost_check(cost)
    puts 'Cost must be a positive number and cannot have more than two decimal places'
    return
  end

  @storage_manager.subscription_manager.update_subscription(sub.name, cost.to_f)
  puts "Subscription cost for %s updated to $%.2f successfully." % [sub.name, cost]
end

def delete
  puts 'Enter name of subscription to be deleted:'
  name = gets.chomp.strip
  if name == ''
    puts 'Name cannot be empty'
    return
  end

  # Find the subscription first (ignoring case) so a missing name is reported right away
  sub = @storage_manager.subscription_manager.find_subscription(name)
  if sub.nil?
    puts "Subscription named #{name} not found in subscription list."
    return
  end

  puts "Delete subscription named \'#{sub.name}\'? Enter \'y\' or \'yes\' to confirm:"
  answer = gets.chomp.strip
  if answer != 'y' && answer != 'yes'
    puts 'Deletion canceled.'
    return
  end

  @storage_manager.subscription_manager.delete_subscription(sub.name)
  puts "Subscription #{sub.name} deleted successfully."
end

def save
  save_out = @storage_manager.save_list
  puts 'Current working directory does not support saving and loading.' if save_out != 0
  puts 'Please end SubTrack and navigate to correct directory.' if save_out != 0
end

def load
  load_out = @storage_manager.load_list
  if load_out == 2
    puts 'No saved subscription list found. Use \'save\' first.'
  elsif load_out != 0
    puts 'Current working directory does not support saving and loading.'
    puts 'Please end SubTrack and navigate to correct directory.'
  else
    @storage_manager.skipped_duplicates.each do |name|
      puts "Skipped duplicate subscription '#{name}' in saved file."
    end
  end
end

# Begin program
subtrack_init

loop do
  # Exit cleanly if input ends (e.g. Ctrl-D)
  line = gets
  break if line.nil?
  input = line.chomp.strip

  case input

  when 'a', 'add'
    add

  when 'l', 'list'
    list

  when 'search'
    search

  when 'filter'
    filter

  when 'summary'
    summary

  when 'h', 'help'
    help

  when 'update'
    update

  when 'delete'
    delete

  when 'q', 'quit'
    puts 'Thank you for using SubTrack!'
    puts 'Exiting.'
    break

  when 'save'
    save

  when 'load'
    load

  else
    puts "Unknown command '#{input}'. Type 'h' for help."
  end

  puts ''
  puts 'Awaiting next input:'
end