class Fibber
  
  def initialize(num = nil)
    @number = num ? gen_number(num) : 1
  end
  
  def gen_number(num)
    gen_series(num).last
  end
  
  def gen_series(num)
    @series = fill_fib(Array.new(num))
  end
  
  def to_i
    @number
  end
  
  def to_a
    @series
  end
  
  private
  
  def fill_fib(series)
    series[0] = 1
    series.each_with_index do |num,idx|
      next if idx == 0
      p1 = series[idx-1] || 0
      p2 = series[idx-2] || 0
      series[idx] = p1+p2
    end
    series
  end
end