require_relative 'subscription'

class SubscriptionManager
  def initialize
    @subscription_list = []
    @year_cost = 0.0
  end

  attr_reader :subscription_list
  attr_reader :year_cost

  # Monthly equivalent of all subscriptions (yearly plans spread over 12 months)
  def month_cost
    @year_cost / 12
  end

  # Finds a subscription by its full name, ignoring case ('netflix' finds 'Netflix',
  # but not 'Netflix Premium'). Returns nil if not found.
  def find_subscription(name)
    subscription_list.find { |sub| sub.name.casecmp?(name) }
  end

  def subscription_exists?(name)
    !find_subscription(name).nil?
  end

  def add_subscription(name, cost, cat_arg: '', freq_arg: 'month', renew_arg: Date.new(2000, 1, 1))
    # Names are unique, ignoring case
    raise ArgumentError, "A subscription named '#{name}' already exists" if subscription_exists?(name)

    # Subscription validates its own fields and raises ArgumentError if any are invalid
    sub =Subscription.new(name, cost, cat_arg: cat_arg, freq_arg: freq_arg, renew_arg: renew_arg)

    # increment year cost
    @year_cost += sub.yearly_cost

    # add to list
    @subscription_list << sub
  end

  def delete_subscription(name)
    # Delete subscription by name
    sub = find_subscription(name)

    # If subscription of 'name' not found, return 1.
    return 1 if sub.nil?

    # Subtract cost from yearly cost, then delete
    @year_cost -= sub.yearly_cost
    subscription_list.delete(sub)
    return 0
  end

  def update_subscription(name, cost)
    # Update cost for named subscription
    sub = find_subscription(name)

    # If subscription of 'name' not found, return 1.
    return 1 if sub.nil?

    # Update cost in yearly cost first
    @year_cost -= sub.yearly_cost

    # Catch cases where cost is nonpositive (should be prevented by subtrack)
    begin
      sub.cost = cost
    rescue ArgumentError => error
      puts "error: #{error.message}"
    end

    @year_cost += sub.yearly_cost
    return 0
  end

  # Returns subscriptions whose name contains the query (case-insensitive)
  def search_subscriptions(query)
    subscription_list.select { |sub| sub.name.downcase.include?(query.downcase) }
  end

  # Returns subscriptions in the given category (case-insensitive).
  # 'N/A' matches subscriptions with no category, since that is how the list displays them.
  def filter_by_category(category)
    subscription_list.select { |sub| category_name(sub).downcase == category.downcase }
  end

  def list_subscriptions
    puts format_subscription_list
  end

  # Builds the subscription list as an aligned table (returned as a string for easy testing)
  def format_subscription_list
    return 'Subscription list empty.' if @subscription_list.empty?

    "Displaying subscription list:\n" + format_table(subscription_list)
  end

  # Builds an aligned table of the given subscriptions, with a header row
  def format_table(subs)
    headers = ['Name', 'Cost', 'Frequency', 'Category', 'Renewal']
    rows = subs.map do |sub_item|
      [sub_item.name, '$%.2f' % sub_item.cost, sub_item.frequency, category_name(sub_item), sub_item.renewal.to_s]
    end

    # Width of each column is its longest entry
    widths = headers.each_index.map { |col| ([headers] + rows).map { |row| row[col].length }.max }
    format_row = ->(row) { row.each_with_index.map { |cell, col| cell.ljust(widths[col]) }.join('  ').rstrip }

    lines = [format_row.call(headers), widths.map { |w| '-' * w }.join('  ')]
    lines += rows.map { |row| format_row.call(row) }
    lines.join("\n")
  end

  private

  # Category as displayed: 'N/A' if empty
  def category_name(sub)
    sub.category.nil? || sub.category == '' ? 'N/A' : sub.category
  end
end