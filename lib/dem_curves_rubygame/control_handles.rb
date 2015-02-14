require 'rubygame'
require 'matrix'

module DemCurves
  module RubygameUtils
    def self.populate_handles(ctl_points, drag_group)
      ctl_points.each do |control_point|
        new_handle = EditorHandle.new
        new_handle.attach_to control_point
        drag_group << new_handle
      end
    end
    
    class DragGroup < Rubygame::Sprites::Group
      dragged_object = nil
      
      def on_press(evt)
        self.each do |sprite|
          if sprite.rect.collide_point? *evt.pos
            @dragged_object = sprite
            break
          end
        end
      end
      
      def on_release(evt)
        @dragged_object = nil
      end
      
      def on_move(evt)
        if @dragged_object
          @dragged_object.move evt.rel
        end
      end
    end
    
    
    class EditorHandle
      include Rubygame::Sprites::Sprite
      
      def initialize(loc=[50, 50], size=10)
        @groups =[]
        @depth = 0
        
        @rect = Rubygame::Rect.new 0, 0, size, size
        @rect.c = loc
        
        @image = Rubygame::Surface.new [size, size], 0, [Rubygame::HWSURFACE, Rubygame::SRCALPHA]
        @image.fill([180, 180, 180])
        @attached = false
        
        @constraints = []
      end
      
      def attach_to(control_point)
        unless @attached
          @attached = true
          @control_point = control_point
          @rect.c = control_point.loc.to_a
        end
      end
      
      def move(rel)
        if @attached
          @control_point.shift rel
        end
      end
      
      def update
        if @attached
          @rect.c = @control_point.loc.to_a
        end
      end
    end
  end
end