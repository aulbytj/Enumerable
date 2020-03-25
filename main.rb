TODO = 'finish implementing the range for my_each'.freeze

module Enumerable
  # @return [Enumerable]
  def my_each
    return to_enum :my_each unless block_given?

    index = 0
    while index < size
      if is_a? Array
        yield self[index]
      elsif is_a? Hash
        yield keys[index], self[keys[index]]
      elsif is_a? Range
        yield to_a[index]
      end
      index += 1
    end
  end

  def my_each_with_index
    return to_enum :my_each unless block_given?

    index = 0
    while index < size
      if is_a? Array
        yield self[index], index
      elsif is_a? Hash
        yield keys[index], self[keys[index]]
      elsif is_a? Range
        yield to_a[index], index
      end
      index += 1
    end
  end

  def my_select
    return to_enum :my_select unless block_given?

    if is_a? Array
      results = []
      my_each { |x| results << x if yield x }
    else
      results = {}
      my_each { |k, v| results[k] = v if yield k, v }
    end
  end

  def my_any?
    if !self[0].nil?
      my_each { |x| return true if self[0] == x }
    elsif block_given?
      my_each { |item| return true if yield(item) }
    else
      my_each { |item| return true if item }
    end
    false
  end

  def my_map(&block)
    return to_enum :my_map unless block_given?

    results = []
    my_each { |x| results << block.call(x) }
  end

end

list = [1, 3, 4, 6, 78, 9]
r_list = (1..10)
myhash = { one: 'one', two: 'two', three: 'three' }

# strings = %w[bill paul dan me mikey]
# r_list.my_each { |x| puts x }
puts
# list.my_each { |x| puts x }
puts
# r_list.my_each_with_index {|k,v| puts "#{k}: #{v}"}
# r_list.each { |x| puts x }

# strings.select { |x| puts x if x.size > 3 }
# puts
# r_list.select { |x| puts x if x > 1 }

# list.my_map { |x| puts x * 2 }
r_list.my_map { |k, v| puts [k.to_s, v] }







