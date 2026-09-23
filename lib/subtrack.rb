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

  # Cost and check
  puts 'Enter subscription cost (dollars and cents):'
  cost = gets.chomp.strip
  if !cost_check(cost)
    puts 'Cost must be a number and cannot have more than two decimal places'
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

  # Run "add" method from storage_manager.rb
  @storage_manager.subscription_manager.add_subscription(name, cost, cat_arg: category, freq_arg: frequency, renew_arg: Date.parse(renewal))
end

# Checks if cost is number with at most two decimal points
def cost_check(cost)
  BigDecimal(cost) == BigDecimal(cost).ceil(2)
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
  # Basic implementation
  @storage_manager.subscription_manager.list_subscriptions
end

def save
  @storage_manager.save_list
end

def load
  @storage_manager.load_list
end

# Begin program
subtrack_init

loop do
  # When file 
  input = gets.chomp.strip

  case input

  when 'a', 'add'
    add

  when 'l', 'list'
    list

  when 'h', 'help'
    help

  when 'q', 'quit'
    puts 'Thank you for using SubTrack!'
    puts 'Exiting.'
    break

  when 'save'
    save

  when 'load'
    load

  else 
    puts 'todo'
  end

  puts ''
  puts 'Awaiting next input:'
end