# The backend files
require 'core/control-point.rb'
require 'core/constraint.rb'
require 'core/path-element.rb'
require 'core/path.rb'
require 'core/util.rb'

# These are the utils for integration with rubygame
begin
  require 'rubygame'
  unless Rubygame::Surface.public_method_defined? :draw_line
    raise LoadError, 'Loading the Rubygame utils for DemCurves requires SDL_GFX to be present on the system'
  end
  
  require 'rubygame-util/control-handles.rb'
  require 'rubygame-util/gfx.rb'
rescue LoadError => e
  puts 'The Rubygame utils for DemCurves require SDL_GFX and Rubygame.'
end