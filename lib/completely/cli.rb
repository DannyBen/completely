require 'mister_bin'
require 'completely/command'
require 'completely/version'

module Completely
  class CLI
    def self.runner
      MisterBin::Runner.new handler: Command
    end
  end
end
