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

# Just in case the developer's environment contains these, we don't need them
ENV['COMPLETELY_DEBUG'] = nil
ENV['COMPLETELY_OUTPUT_PATH'] = nil
ENV['COMPLETELY_CONFIG_PATH'] = nil

def reset_tmp_dir
  system 'rm -rf spec/tmp/*'
  system 'mkdir -p spec/tmp'
end
