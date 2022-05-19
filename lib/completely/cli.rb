require 'mister_bin'
require 'completely/commands/init'
require 'completely/commands/preview'
require 'completely/commands/generate'
require 'completely/commands/test'
require 'completely/version'

module Completely
  class CLI
    def self.runner
      runner = MisterBin::Runner.new version: Completely::VERSION,
        header: "Completely - Bash Completions Generator",
        footer: "Run !txtpur!completely COMMAND --help!txtrst! for more information"

      runner.route 'init',      to: Commands::Init
      runner.route 'preview',   to: Commands::Preview
      runner.route 'generate',  to: Commands::Generate
      runner.route 'test',      to: Commands::Test

      runner
    end
  end
end
