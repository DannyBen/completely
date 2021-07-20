require 'simplecov'
SimpleCov.start

require 'bundler'
Bundler.require :default, :development

require 'completely'
include Completely

# Consistent Colsole output (for rspec_aprovals)
ENV['TTY'] = 'off'
ENV['COLUMNS'] = '80'
ENV['LINES'] = '30'
