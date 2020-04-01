# rubocop: disable Metrics/ModuleLength
# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

module Enumerable
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
    block_is_true = false
    if block_given? && args.nil?
      my_each { |x| block_is_true = true if yield(x) }
    elsif args.is_a? Regexp
      my_each { |x| block_is_true = true if x.match(args) }
    elsif args.is_a? Module
      my_each { |x| block_is_true = true if x.is_a?(args) }
    else
      my_each { |x| block_is_true = true if x.nil? || x == false }
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
    elsif !block_given? || args.nil?
      my_each { |x| block_is_true = true unless x.nil? || x == false }
    else
      my_each { |x| block_is_true = false unless x == true }
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
      my_each { |x| block_is_true = false unless x.nil? || x == false }
    end
    block_is_true
  end

  def my_inject(initial = nil, second = nil)
    arr = is_a?(Array) ? self : to_a
    sym = initial if initial.is_a?(Symbol) || initial.is_a?(String)
    acc = initial if initial.is_a? Integer

    if initial.is_a?(Integer)
      sym = second if second.is_a?(Symbol) || second.is_a?(String)
    end

    if sym
      arr.my_each { |x| acc = acc ? acc.send(sym, x) : x }
    elsif block_given?
      arr.my_each { |x| acc = acc ? yield(acc, x) : x }
    end
    acc
  end
  alias my_reduce my_inject

  def multiply_els
    my_inject { |result, num| result * num }
  end

  # rubocop: enable Metrics/ModuleLength
  # rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
end
