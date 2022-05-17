require 'mister_bin'
require 'completely/command'

module Completely
  class CLI
    def self.runner
      MisterBin::Runner.new handler: Command
    end
  end
end
