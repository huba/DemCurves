module DemCurves
  module BaseConstraint
    master_point = nil
    slave_points = []
    
    def notify(src, orig_src, params)
      if src == @master_point
        handle_master src, orig_src, params
      elsif @slave_points.include? src
        handle_slave src, orig_src, params
      end
    end
    
    def handle_master(master, orig_src, params)
      # This has to be implemented by the class
    end
    
    def handle_slave(slave, orig_src, params)
      # This has to be implemented by the class
    end
  end
  
  
  class LineUpConstraint
    include BaseConstraint
    def initialize(pivot, p0, p1, mirror_distance=false, follow=:pivot)
      pivot.add_constraint self
      p0.add_constraint self
      p1.add_constraint self
      
      @master_point = pivot
      @slave_points = [p0, p1]
      @mirror_distance = mirror_distance
      @follow = follow
      p1.move_to p1.loc #hacky way to trigger readjustment
    end
    
    def handle_master(master, orig_src, params)
      if (params.include? :new_pos and params.include? :old_pos) or params.include? :rel
        case @follow
        when :pivot
          unless params.include? :rel
            params[:rel] = params[:new_pos], params[:old_pos]
          end
          
          params.delete(:new_pos)
          params.delete(:old_pos)
          
          @slave_points.each do |slave|
            slave.notify_to_move orig_src, self, params
          end
        when :p0
          direction = (params[:new_pos] - @slave_points[0].loc).unit
          distance = (params[:new_pos] - @slave_points[1].loc).r
          @slave_points[1].notify_to_move orig_src, self, {:new_pos => params[:new_pos] + (distance * direction)}
        when :p1
          direction = (params[:new_pos] - @slave_points[1].loc).unit
          distance = (params[:new_pos] - @slave_points[0].loc).r
          @slave_points[0].notify_to_move orig_src, self, {:new_pos => params[:new_pos] + (distance * direction)}
        end
      end
    end
    
    def handle_slave(slave, orig_src, params)
      if params.include? :new_pos
        other_slave = (@slave_points.select {|s| s!=slave})[0]
        direction = (params[:new_pos] - @master_point.loc).unit
        if @mirror_distance
          distance = (slave.loc - @master_point.loc).r
        else
          distance = (other_slave.loc - @master_point.loc).r
        end
        
        new_loc = @master_point.loc + (-1 * direction * distance)
        other_slave.notify_to_move orig_src, self, {:new_pos => new_loc}
      end
    end
  end
end