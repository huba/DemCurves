require 'core/path-element.rb'

module DemCurves
  class Path
    include Enumerable
    attr_reader :path_points, :path_elements, :control_points
    
    def initialize(point)
      @path_elements = []
      
      @start_point = ControlPoint[*point]
      @end_point = @start_point
      
      @path_points = to_a
      @control_points = [@start_point]
    end
    
    def add_bezier(start_handle, end_handle, end_point, tangent_lock=true)
      new_bezier = CubicBezier.new(
      @end_point, 
      ControlPoint[*start_handle],
      ControlPoint[*end_handle],
      ControlPoint[*end_point])
      
      if tangent_lock and @path_elements.last
        start_length = (new_bezier[:start_handle].loc - @end_point.loc).r
        last_element = @path_elements.last
        
        case last_element
        when CubicBezier
          LineUpConstraint.new @end_point, last_element[:end_handle], new_bezier[:start_handle]
        when Line
          LineUpConstraint.new @end_point, last_element[:center], new_bezier[:start_handle], morror_distance=false, follow=:p0
        end
      end
      
      @end_point = new_bezier[:end]
      @path_elements << new_bezier
      
      @path_points = to_a
      @control_points += new_bezier.control_points.values[1..-1]
    end
    
    def add_line(end_point, tangent_lock=true)
      center_point = ControlPoint[*(@end_point.loc + (Vector[*end_point] - @end_point.loc) * 0.5)]
      new_line = Line.new @end_point, center_point, ControlPoint[*end_point]
      LineUpConstraint.new center_point, new_line[:end], @end_point
      
      if tangent_lock and @path_elements.last
        last_element = @path_elements.last
        
        case last_element
        when CubicBezier
          LineUpConstraint.new @end_point, last_element[:end_handle], new_line[:end], morror_distance=false, follow=:p1
        when Line
          @end_point.move_to end_point
          return
        end
      end
      
      @end_point = new_line[:end]
      @path_elements << new_line
      
      @path_points = to_a
      @control_points += new_line.control_points.values[1..-1]
    end
    
    def each
      yield @start_point.loc
      @path_elements.each do |path_element|
        (1..path_element.path_points.size-1).each do |index|
          yield path_element.path_points[index]
        end
      end
    end
    
    def size
      return @path_points.size
    end
    
    def get_guides
      @path_elements.inject([]) do |mem, element|
        mem += element.get_guides
      end
    end
  end
end