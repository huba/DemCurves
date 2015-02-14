# The backend files
require './lib/dem_curves_core/control_point.rb'
require './lib/dem_curves_core/constraint.rb'
require './lib/dem_curves_core/path_element.rb'
require './lib/dem_curves_core/path.rb'
require './lib/dem_curves_core/util.rb'

# These are the utils for integration with rubygame
begin
  require 'rubygame'
  unless Rubygame::Surface.public_method_defined? :draw_line
    raise LoadError, 'Loading the Rubygame utils for DemCurves requires SDL_GFX to be present on the system'
  end
  
  require './lib/dem_curves_rubygame/control_handles.rb'
  require './lib/dem_curves_rubygame/gfx.rb'
rescue LoadError => e
  puts 'The Rubygame utils for DemCurves require SDL_GFX and Rubygame.'
end