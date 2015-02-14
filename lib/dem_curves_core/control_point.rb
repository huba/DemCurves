require 'matrix'
require './lib/dem_curves_core/util.rb'

module DemCurves
  class ControlPoint
    # this class is necessary to let other curves and path elements modify
    # points, it works much better than calling "notify movement" functions
    # every time a control point moves, this comes in handy when you want a curve
    # to use another curve's end point as a starting point.
    attr_reader :loc
    
    def initialize(loc)
      @loc = Vector.elements(loc)
      @path_elements = []
      @constraints = []
    end
    
    def add_path_element(path_element)
      @path_elements << path_element
    end
    
    def replace(other)
      old_pos = @loc
      case other
      when ControlPoint
        @loc = Vector.elements(other.loc)
      when Vector, Array
        unless other.size == 2
          raise "Wrong number of dimensions, must be [x, y]"
        end
        @loc = Vector.elements(other)
      else
        raise "Argument is instance of #{other.class}! Replacement argument must be an instance of Vector, Array or ControlPoint."
      end
        
        @path_elements.each do |path_element|
          path_element.generate
      end
    end
    
    def shift(rel)
      unless rel.size == 2
        raise "Wrong number of dimensions, must be [x, y]"
      end
      
      old_pos = @loc
      move_to @loc + Vector.elements(rel)
    end
    
    def move_to(destination)
      old_pos = @loc
      replace destination
      
      new_pos = @loc
      rel = new_pos - old_pos
      
      @constraints.each do |constraint|
        constraint.notify self, self, {:new_pos => new_pos, :old_pos => old_pos, :rel => rel}
      end
    end
    
    def rotate_around(pivot_ctl, angle)
      offset = @loc - pivot_ctl.loc
      new_offset = Matrix[[Math.cos(angle), -Math.sin(angle)], [Math.sin(angle), Math.cos(angle)]] * offset
      replace new_offset + pivot_ctl.loc
    end
    
    def notify_to_move(orig_src, src_constraint, params)
      unless orig_src == self
        # Safety measure, it avoids infinite recursion, but produces weird results
        # with cyclic constraint structures.
        old_pos = @loc
        if params.include? :new_pos
          replace params[:new_pos]
        elsif params.include? :rel
          replace params[:rel] + @loc
        else
          return
        end
        
        new_pos = @loc
        rel = new_pos - old_pos
        
        @constraints.each do |constraint|
          unless constraint == src_constraint
            constraint.notify self, orig_src, {:new_pos => new_pos, :old_pos => old_pos, :rel => rel}
          end
        end
      end
    end
    
    def add_constraint(constraint)
      unless @constraints.include? constraint
        @constraints << constraint
      end
    end
    
    def clear_constraints
      @constraints = []
    end
  end
  
  def ControlPoint.[](*loc)
    return ControlPoint.new loc
  end
end