# DemCurves
[![Gem Version](https://badge.fury.io/rb/dem-curves.svg)](http://badge.fury.io/rb/dem-curves)

A library for generating bezier curve based paths from control_points. It can be used with Rubygame when Rubygame is installed along with SDL_GFX.

## Installation

### Development version from github
Clone the repository:
```
git clone https://github.com/huba/DemCurves.git
```

Then build the gem:
```
gem build DemCurves.gemspec
```
And install:
```
gem install dem-curves-x.x.x.gem
```

### Latest release from rubygems.org
Simply run:
```
gem install dem-curves
```

## Basic usage
The simplest way to use the library is to use it without a graphical front end this will output 32 ruby Vector objects.
```ruby
require 'dem-curves'

path = DemCurves::Path.new [50, 50]
path.add_bezier [100, 80], [150, 130], [200, 230]

path.each do |path_point|
  puts path_point
end
```

The ```DemCurves::RubygameUtils``` module describes draggable handles that can be attached to the path's control points and the library also extends ```Rubygame::Surface``` with a ```draw_path``` function which takes an instance of ```DemCurves::Path``` and a color and it draws lines between all the points on the surface.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
The MIT License (MIT)

Copyright (c) 2014 Huba Z. Nagy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.