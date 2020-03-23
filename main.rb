# module Enumerable
#   def my_each
#     index = 0
#     while index < length
#       yield self[index]
#       index += 1
#     end
#   end
#   self
# end

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
      end
      index += 1
    end
  end

  def my_each_with_index
    return to_enum :my_each unless block_given?

    index = 0
    while index < length
      if is_a? Array
        yield self[index], index
      elsif is_a? Hash
        yield keys[index], self[keys[index]]
      end
      index += 1
    end
  end

  def my_select

    if is_a? Array
      results = []
      my_each { |x| results << x if yield x }
    else
      results = {}
      my_each { |k, v| results[k] = v if yield k, v }
    end
  end
end

list = [1, 3, 4, 6, 78, 9]
r_list = (1..10)
myhash = { one: 'one', two: 'two', three: 'three' }

strings = %w(bill paul dan me mikey)
r_list.my_each { |x| puts x }

strings.select { |x| puts x if x.size > 3 }
puts
strings.my_select { |x| puts x if x.size > 3 }




