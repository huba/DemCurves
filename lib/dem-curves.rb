# The backend files
require 'core/control-point'
require 'core/constraint'
require 'core/path-element'
require 'core/path'
require 'core/util'

# These are the utils for integration with rubygame
begin
  require 'rubygame'
  unless Rubygame::Surface.public_method_defined? :draw_line
    raise LoadError, 'Loading the Rubygame utils for DemCurves requires SDL_GFX to be present on the system'
  end
  
  require 'rubygame-util/control-handles'
  require 'rubygame-util/gfx'
rescue LoadError => e
  puts 'The Rubygame utils for DemCurves require SDL_GFX and Rubygame.'
end