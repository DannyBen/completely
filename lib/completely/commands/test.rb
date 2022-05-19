require 'completely/commands/base'

module Completely
  module Commands
    class Test < Base
      summary "Test completions"

      help <<~EOF
        This command can be used to test that any completion script (either generated by compeltely or not) responds with the right completions.

        In order to test on a completely configuration file other than 'completely.yaml', set the COMPLETELY_CONFIG_PATH environemnt variable.

        In order to test on an arbitrary completions script, set the COMPLETELY_SCRIPT_PATH and COMPLETELY_SCRIPT_FUNCTION environment variables.
      EOF

      usage "completely test COMPLINE"
      usage "completely test (-h|--help)"

      param "COMPLINE", "The command to test completions for. This will be handled as if a TAB was pressed immediately at the end of it, so the last word is considered the active cursor. If you wish to complete for the next word instead, end your command with a space."

      environment "COMPLETELY_CONFIG_PATH", "Path to a completely configuration file [default: completely.yaml]"
      environment "COMPLETELY_SCRIPT_PATH", "Path to a completions script. When set, this script will be tested instead of the completely configuration file"
      environment "COMPLETELY_SCRIPT_FUNCTION", "The main completion function to call when using a custom script"

      example %q[completely test "mygit pu"]
      example %q[completely test "mygit pull "]
      example <<~EOF
        COMPLETELY_SCRIPT_PATH=/usr/share/bash-completion/completions/git \\
          COMPLETELY_SCRIPT_FUNCTION=_git \\
          completely test "git pu"
        EOF

      attr_reader :config, :script_path, :script_function

      def run
        set_vars
        puts tester.test(compline).join "\n"
      end

    private

      def compline
        args['COMPLINE']
      end

      def tester
        if config
          completions = Completions.load config
          completions.tester
        else
          Tester.new script: File.read(script_path), function_name: ENV['COMPLETELY_SCRIPT_FUNCTION']
        end
      end

      def set_vars
        if ENV['COMPLETELY_CONFIG_PATH']
          @config = ENV['COMPLETELY_CONFIG_PATH']
        elsif ENV['COMPLETELY_SCRIPT_PATH'] and ENV['COMPLETELY_SCRIPT_FUNCTION']
          @script_path = ENV['COMPLETELY_SCRIPT_PATH']
          @script_function = ENV['COMPLETELY_SCRIPT_FUNCTION']
        elsif File.exist? 'completely.yaml'
          @config = 'completely.yaml'
        else
          raise "Please set the proper environment variables or run in a folder with completely.yaml"
        end
      end
    end
  end
end
