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
end

def add
  puts 'Enter subscription name:'
  name = gets.chomp.strip
  puts 'Enter subscription cost (dollars and cents):'
  cost = gets.chomp.strip

  # Run "add" method from storage_manager.rb
  # temporary:
  @storage_manager.subscription_manager.add_subscription(name, cost)
end

def list
  # Basic implementation
  @storage_manager.subscription_manager.list_subscriptions
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
  else 
    puts 'todo'
  end
  puts 'Awaiting next input:'
end