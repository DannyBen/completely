if ENV['BYEBUG']
  require 'byebug'
  require 'lp'
end

require 'completely/exceptions'
require 'completely/pattern'
require 'completely/completions'
require 'completely/tester'
require 'completely/installer'
