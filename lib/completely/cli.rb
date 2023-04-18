require 'mister_bin'
require 'completely/version'
require 'completely/commands/generate'
require 'completely/commands/init'
require 'completely/commands/install'
require 'completely/commands/preview'
require 'completely/commands/test'

module Completely
  class CLI
    def self.runner
      runner = MisterBin::Runner.new version: Completely::VERSION,
        header: 'Completely - Bash Completions Generator',
        footer: 'Run m`completely COMMAND --help` for more information'

      runner.route 'init',      to: Commands::Init
      runner.route 'preview',   to: Commands::Preview
      runner.route 'generate',  to: Commands::Generate
      runner.route 'test',      to: Commands::Test
      runner.route 'install',   to: Commands::Install

      runner
    end
  end
end
