require 'simplecov'
SimpleCov.start

require 'bundler'
Bundler.require :default, :development

require 'completely'
require 'completely/cli'
include Completely

# Consistent Colsole output (for rspec_aprovals)
ENV['TTY'] = 'off'
ENV['COLUMNS'] = '80'
ENV['LINES'] = '30'

def reset_tmp_dir
  system 'rm -rf spec/tmp/*'
  system 'mkdir -p spec/tmp'
end
