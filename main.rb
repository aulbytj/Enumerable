TODO = 'finish implementing the range for my_each'.freeze
# rubocop: disable Metrics/ModuleLength
# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

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
    results
  end

  def my_any?(args = nil)
    block_is_true = true
    if block_given?
      my_each { |x| block_is_true = false unless yield(x) }
    end
    block_is_true
  end

  def my_map(&proc)
    return to_enum :my_map unless block_given?

    results = []
    my_each { |x| results << proc.call(x) }
    results
  end

  def my_all?(args = nil)
    block_is_true = true
    if block_given?
      my_each { |x| block_is_true = false unless yield(x) }
    elsif args.is_a? Regexp
      my_each { |x| block_is_true = false unless x.match(args) }
    elsif args.is_a? Module
      my_each { |x| block_is_true = false unless x.is_a?(args) }
    elsif !block_given?
      my_each { |x| block_is_true = false unless x == true }
    else
      my_each { |x| block_is_true = false unless x.nil? || x == false }
    end
    block_is_true
  end

  def my_count(args = nil)
    counter = 0
    if block_given?
      my_each { |x| counter += 1 if yield(x) }
    elsif !args.nil?
      my_each { |x| counter += 1 if args == x }
    else
      counter = length
    end
    counter
  end

  def my_none?(args = nil)
    block_is_true = true
    if block_given?
      my_each { |x| block_is_true = false if yield(x) }
    elsif args.is_a? Regexp
      my_each { |x| block_is_true = false if x.match(args) }
    elsif args.is_a? Module
      my_each { |x| block_is_true = false if x.is_a?(args) }
    elsif !block_given?
      my_each { |x| block_is_true = false if x == true }
    else
      my_each { |x| block_is_true = false if x.nil? || x == false }
    end
    block_is_true
  end





end

# puts %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
# puts %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
# puts %w[ant bear cat].my_all?(/t/)                        #=> false
# puts [1, 2i, 3.14].my_all?(Numeric)                       #=> true
# puts [nil, true, 99].my_all?                              #=> false
# puts [].my_all?                                           #=> true

puts %w[ant bear cat].any? { |word| word.length >= 3 } #=> true
puts %w[ant bear cat].any? { |word| word.length >= 4 } #=> true
puts %w[ant bear cat].any?(/d/)                        #=> false
puts [nil, true, 99].any?(Integer)                     #=> true
puts [nil, false, 99].any?                              #=> true
puts [].any?                                           #=> false

# puts [1,2,3,4,5].my_select { |num|  num.even?  }   #=> [2, 4]
# puts (1..4).my_map { |i| i*i }      #=> [1, 4, 9, 16]

# ary = [1, 2, 4, 2]
# puts ary.my_count               #=> 4
# puts ary.my_count(2)            #=> 2
# puts ary.my_count { |x| x%2==0 } #=> 3

# puts %w{ant bear cat}.my_none? { |word| word.length == 5 } #=> true
# puts %w{ant bear cat}.my_none? { |word| word.length >= 4 } #=> false
# puts %w{ant bear cat}.my_none?(/d/)                        #=> true
# puts [1, 3.14, 42].my_none?(Float)                         #=> false
# puts [1].my_none?                                           #=> true
# puts [nil].my_none?                                        #=> true
# puts [nil, false].my_none?                                 #=> true
# puts [nil, false, true].my_none?                           #=> false
