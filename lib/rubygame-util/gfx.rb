require 'rubygame'

class Rubygame::Surface
  def draw_path(path, color)
    (0..path.size - 2).each do |index|
      _draw_line path.to_a[index], path.to_a[index + 1], color, false
    end
  end
  
  def draw_path_a(path, color)
    (0..path.size - 2).each do |index|
      _draw_line path.to_a[index], path.to_a[index + 1], color, true
    end
  end
end