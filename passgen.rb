class Passgen
  
  def generate(len = 8)
    random_alpha_string(len.to_i)
  end
  
  def generate_series(num,len = 8)
    (1..num.to_i).to_a.map { |s| generate(len) }
  end
  
  private
  
  def random_alpha_string(len)
    chars = ['a'..'z','A'..'Z'].map { |s| [*s] }.flatten
    (1..len).to_a.map { chars[rand(chars.length - 1)] }.join
  end
end