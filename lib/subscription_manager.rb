require_relative 'subscription'

class SubscriptionManager
  def initialize
    @subscription_list = []
    @year_cost = 0.0
  end

  attr_reader :subscription_list
  attr_reader :year_cost

  def add_subscription(name, cost, cat_arg: '', freq_arg: 'month', renew_arg: Date.new(2000, 1, 1))
    # checks 
    sub = Subscription.new(name, cost, cat_arg: cat_arg, freq_arg: freq_arg, renew_arg: renew_arg)

    # increment year cost
    @year_cost += sub.yearly_cost

    # add to list
    @subscription_list << sub
  end

  def delete_subscription(name)
    # Delete subscription by name
    subscription_list.each_with_index do |sub, idx|
      if sub.name == name
        # Subtract cost from yearly cost, then delete 
        @year_cost -= subscription_list[idx].yearly_cost
        subscription_list.delete_at(idx)
        return 0
      end
    end

    # If subscription of 'name' not found, return 1.
    return 1
  end

  def update_subscription(name, cost)
    # Update cost for named subscription 
    subscription_list.each_with_index do |sub, idx|
      if sub.name == name
        # Update cost in yearly cost first
        @year_cost -= subscription_list[idx].yearly_cost

        # Catch cases where cost is nonpositive (should be prevented by subtrack)
        begin 
          subscription_list[idx].cost = cost
        rescue ArgumentError => error
          puts "error: #{error.message}"
        end

        @year_cost += subscription_list[idx].yearly_cost
        return 0
      end
    end

    # If subscription of 'name' not found, return 1.
    return 1
  end

  def list_subscriptions
    puts format_subscription_list
  end

  # Builds the subscription list as an aligned table (returned as a string for easy testing)
  def format_subscription_list
    return 'Subscription list empty.' if @subscription_list.empty?

    headers = ['Name', 'Cost', 'Frequency', 'Category', 'Renewal']
    rows = subscription_list.map do |sub_item|
      # Display 'N/A' for category if empty
      cat_name = sub_item.category.nil? || sub_item.category == '' ? 'N/A' : sub_item.category
      [sub_item.name, '$%.2f' % sub_item.cost, sub_item.frequency, cat_name, sub_item.renewal.to_s]
    end

    # Width of each column is its longest entry
    widths = headers.each_index.map { |col| ([headers] + rows).map { |row| row[col].length }.max }
    format_row = ->(row) { row.each_with_index.map { |cell, col| cell.ljust(widths[col]) }.join('  ').rstrip }

    lines = ['Displaying subscription list:', format_row.call(headers), widths.map { |w| '-' * w }.join('  ')]
    lines += rows.map { |row| format_row.call(row) }
    lines.join("\n")
  end
end