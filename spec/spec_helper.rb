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
ENV['LC_COLLATE'] = 'C'   # consistent sort order

def reset_tmp_dir
  system 'rm -rf spec/tmp/*'
  system 'mkdir -p spec/tmp'
end

def run_completions(fixture:, compline:, cword:)
  subject = Completions.load "spec/fixtures/integration/#{fixture}.yaml", function_name: '_testme'

  script = subject.script
  File.write "spec/tmp/test.sh", <<~BASH
    #{subject.script}

    COMP_WORDS=( #{compline} )
    COMP_CWORD=#{cword}
    _testme
    echo "${COMPREPLY[*]}"
  BASH

  Dir.chdir 'spec/fixtures/integration' do
    `bash ../../../spec/tmp/test.sh`.chomp
  end
end