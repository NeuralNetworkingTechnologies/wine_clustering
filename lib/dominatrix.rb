require 'narray'

class Dominatrix < NMatrix
  include Enumerable
  
  def each_index(&block)
    n, m = shape
    n.times do |i|
      yield i
    end
  end

  def each(&block)
    n, m = shape
    m.times.each do |row|
      yield n.times.map {|column| self[column, row] }
    end
  end

  def data_items
    self
  end
  
  def data_labels
    @labels ||= shape.first.times.map {|i| "V#{i}"}
  end
end
