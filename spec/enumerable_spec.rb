require_relative('../main')
describe Enumerable do
  let(:range) { (5..10) }
  let(:bool) { [nil, false, 99] }
  let(:hash) { { name: 'jay', age: 34 } }
  let(:string_array) { %w[rabbit cat dog goat] }
  let(:number_array) { [16, 20, 19, 80, 65, 13, 30] }
  let(:empty_array) { [] }
  let(:mix_array) { [1, 2, 'ten', 3.5, %w[hello world!]] }

  describe '#my_each' do
    it 'returns enumerator' do
      expect(number_array.my_each).to(be_an(Enumerator))
    end

    it 'calls the block for each of the item in the array' do
      my_each_output = 0
      block = proc { |num| my_each_output += num }
      number_array.my_each.to_a(&block)
      each_output = 0
      number_array.each.to_a(&block)
      expect(my_each_output).to(eql(each_output))
    end

    it 'calls the block for each of the item in the hash' do
      each_output = ''
      block = proc { |key, val| each_output += "#{key} #{val}" }
      hash.my_each(&block)
      my_each_output = each_output.dup
      each_output = ''
      hash.each(&block)
      expect(my_each_output).to(eql(each_output))
    end

    it 'calls the block for each of the item in the array' do
      my_each_output = 0
      block = proc { |num| my_each_output += num }
      range.my_each.to_a(&block)
      each_output = 0
      range.each.to_a(&block)
      expect(my_each_output).to(eql(each_output))
    end
  end

  describe '#my_each_with_index' do
    it 'returns enumerator' do
      expect(mix_array.my_each).to(be_an(Enumerator))
    end

    it 'calls the block for each of the item in the array' do
      mewi = []
      block = proc { |_elem, idx| mewi[idx] = idx }
      number_array.my_each_with_index.to_a(&block)
      ewi = []
      number_array.each_with_index.to_a(&block)
      expect(mewi).to(eql(ewi))
    end

    it 'my_each_with_index should return the same as each_with_index' do
      mewi = []
      block = proc { |_elem, idx| mewi[idx] = idx }
      range.my_each_with_index.to_a(&block)
      ewi = []
      range.each_with_index.to_a(&block)
      expect(mewi).to(eql(ewi))
    end

    it 'my_each_with_index should return the same as each_with_index ' do
      ewi = {}
      block = proc { |elem, idx| ewi[elem] = idx }
      hash.my_each_with_index.to_s(&block)
      mewi = ewi.dup
      ewi = {}
      hash.each_with_index.to_s(&block)
      expect(mewi).to(eq(ewi))
    end
  end

  describe '#my_select' do
    it 'should return the even values' do
      expect(number_array.my_select(&:even?)).to(eq([16, 20, 80, 30]))
    end
  end

  describe '#my_any?' do
    it 'should return false' do
      expect(number_array.my_any?(25)).to(eq(false))
    end

    it 'should return true if no element is a number' do
      expect(bool.my_any?(Numeric)).to(eql(true))
    end

    it 'should return false' do
      expect(number_array.my_any?(:even?)).to(eq(false))
    end

    it 'should return true' do
      expect(string_array.my_any?(/d/)).to(eq(true))
    end
  end

  describe '#my_all?' do
    it 'should return true' do
      expect(empty_array.my_all?).to(eq(true))
    end

    it 'should return true if all elements are numbers' do
      expect(number_array.my_all?(Numeric)).to(be_truthy)
    end

    it 'should return false' do
      expect(string_array.my_all?(/t/)).to(eq(false))
    end

    it 'should return true if all elements are less than 100' do
      expect(number_array.my_all? { |n| n < 100 }).to(eq(true))
    end

    it 'should return false' do
      expect(string_array.my_all? { |word| word.length >= 4 }).to(eql(false))
    end
  end

  describe '#my_count' do
    it 'should return number of items in array' do
      expect(number_array.my_count).to(eq(7))
    end

    it 'should return zero' do
      expect(number_array.my_count { |n| n % 5 == 0 }).to(eq(4))
    end
  end

  describe '#my_map' do
    it 'should return new array with [25. 36, 49, 64, 81, 100]' do
      expect(range.my_map { |i| i * i }).to(eq([25, 36, 49, 64, 81, 100]))
    end
  end

  describe '#my_none?' do
    it 'should return true' do
      expect(bool.my_none?).to(eq(true))
    end

    it 'should return true' do
      expect(number_array.my_none?(Float)).to(eq(true))
    end

    it 'should return false' do
      expect(string_array.my_none?(/t/)).to(eq(false))
    end

    it 'shoudl not return false' do
      expect(string_array.my_none? { |word| word.length == 5 }).to_not(eq(false))
    end
  end

  describe '#my_inject' do
    it 'should returnn 45' do
      expect(range.my_inject { |acc, elem| acc + elem }).to(eq(45))
    end

    it 'should return rabbit' do
      block = proc { |memo, word| memo.length > word.length ? memo : word }
      expect(string_array.my_inject(&block)).to(eq('rabbit'))
    end

    it 'should return 151200 when called with my_reduce alias to my_inject' do
      expect(range.my_reduce(1, :*)).to(eq(151_200))
    end
  end
end
