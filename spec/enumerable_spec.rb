require_relative('../main')
describe Enumerable do
  describe '#my_each' do
    it 'returns enumerator' do
      expect(%i[1 2 4 5 6].my_each).to(be_an(Enumerator))
    end

    it 'my_each should return the same as each' do
      expect(%i[1 2 4 5 6].my_each.to_a).to(eql(%i[1 2 4 5 6].each.to_a))
    end

    it 'should returns key, value pair' do
      expect({ name: 'jay', age: 34 }.my_each.to_h).to(eq({ name: 'jay', age: 34 }.each.to_h))
    end

    it 'returns elements in the range' do
      expect(%i[0..10].my_each.to_a).to(eq(%i[0..10].each.to_a))
    end
  end

  describe '#my_each_with_index' do
    it 'returns enumerator' do
      expect([1, 2, 'ten', 3.5, %w[hello world!]].my_each).to(be_an(Enumerator))
    end

    it 'should return the indexes' do
      hash = {}
      %w[cat dog fish].my_each_with_index { |v, i| hash[v] = i }
      expect(hash).to(eq({ "cat" => 0, "dog" => 1, "fish" => 2 }))
    end
  end

  describe '#my_select' do
    it 'should return the even values' do
      expect([1, 2, 3, 4, 5, 6, 7, 8, 9].select { |n| n % 3 == 0 }).to(eq([3, 6, 9]))
    end
  end

  describe '#my_any?' do
    it 'should return true' do
      expect([nil, true, 99].any?).not_to(eq(false))
    end

    it 'should return false' do
      expect(%w[ant bear cat].any?(/d/)).to(eq(false))
    end
  end

  describe '#my_all?' do
    it 'should return true' do
      expect([].all?).to(eq(true))
    end

    it 'should return false' do
      expect(%w[ant bear cat].all? { |word| word.length >= 4 }).to(eql(false))
    end
  end

  describe '#my_count' do
    it 'should return number of items in array' do
      expect([61, 51, 41, 31, 21, 11].my_count).to(eq(6))
    end

    it 'should return zero' do
      expect([64, 52, 41, 31, 22, 11].my_count { |n| n % 3 == 0 }).to(eq(0))
    end
  end

  describe '#my_map' do
    it 'should return new array with [1, 4, 9, 16]' do
      expect((1..4).map { |i| i * i }).to(eq([1, 4, 9, 16]))
    end
  end

  describe '#none' do
    it 'should return true' do
      expect([nil, false].none?).to(eq(true))
    end

    it 'shoudl not return false' do
      expect(%w[ant bear cat].none? { |word| word.length == 5 }).to_not(eq(false))
    end
  end

  describe '#my_inject' do
    it 'should returnn 45' do
      expect((5..10).reduce { |sum, n| sum + n }).to(eq(45))
    end

    it 'should return sheep' do
      longest =
        %w[cat sheep bear].reduce do |memo, word|
          memo.length > word.length ? memo : word
        end
      expect(longest).to(eq('sheep'))
    end

    it 'should return 151200' do
      expect((5..10).reduce(1, :*)).to(eq(151_200))
    end
  end
end
