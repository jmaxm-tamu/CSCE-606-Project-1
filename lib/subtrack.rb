require_relative 'storage_manager'

def init 
  puts 'Welcome to Subtrack!'
  puts 'This is a system for cataloguing, tracking, and saving your current subscriptions.'
  puts 'Type \'h\' for help.'
end

def help
  puts 'To add a subscription, type \'add\'.'
  puts 'To list currently saved subscriptions, type \'list\'.'
end

init
loop do
  # When file 
  input = gets.chomp.strip
  case input
  when 'h', 'help'
    help
  when 'q', 'quit'
    puts 'Thank you for using SubTrack!'
    puts 'Exiting.'
    break
  else 
    puts 'todo'
  end
end