require './lib/dem_curves_core/util.rb'

module DemCurves
  class PathElement
    # Do not directly instantiate this class
    attr_reader :path_points, :control_points
    def initialize(control_points)
      @control_points = control_points
      @control_points.each_value do |control_point| 
        control_point.add_path_element self
      end
      
      @path_points = []
      generate
    end
    
    def generate
      @path_points = @control_points.values.collect {|point| point.loc}
    end
    
    def set_control(control_id, loc)
      unless control_id.class == Symbol 
        raise 'control_id must be a symbol' 
      end
      
      @control_points[control_id].move_to location
      generate
    end
    
    def []=(control_id, loc)
      set_control control_id, loc
    end
    
    def get_control(control_id)
      unless control_id.class == Symbol 
        raise 'control_id must be a symbol' 
      end
      
      return @control_points[control_id]
    end
    
    def [](control_id)
      get_control control_id
    end
  end
  
  
  class CubicBezier < PathElement
    def initialize(start_point, start_handle, end_handle, end_point)
      super({
        :start => start_point, 
        :start_handle => start_handle, 
        :end_handle => end_handle, 
        :end => end_point})
    end
    
    def generate(t_freq=32)
      step = 1.0 / t_freq
      @path_points = (0..t_freq).collect {|i| interpolate(step * i)}
    end
    
    def interpolate(t)
      # http://mathworld.wolfram.com/BezierCurve.html
      (0..3).inject(Vector[0, 0]) do |mem, i|
        mem += @control_points.values[i].loc.clone * bernstein_basis(i, 3, t)
      end
    end
    
    def get_guides
      # this will be removed soon.
      return [[self[:start].loc, self[:start_handle].loc], [self[:end_handle].loc, self[:end].loc]]
    end
  end
  
  
  class Line < PathElement
    def initialize(start_point, center_point, end_point)
      super({
        :start => start_point,
        :center => center_point,
        :end => end_point})
    end
    
    def generate
      @path_points = [self[:start].loc, self[:end].loc]
    end
  end
end