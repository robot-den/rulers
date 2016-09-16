class Array
  def yay(count=nil)
    if count
      count.times { puts 'yay!' }
    else
      self.length.times { puts 'yay!' }
    end
  end
end
