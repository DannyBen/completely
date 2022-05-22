require 'completely/commands/base'

module Completely
  module Commands
    class Test < Base
      summary "Test completions"

      help "This command can be used to test that your completions script responds with the right completions. It works by reading your completely.yaml file, generating a completions script, and generating a temporary testing script."

      usage "completely test [--keep] COMPLINE"
      usage "completely test (-h|--help)"

      option "-k --keep", "Keep the temporary testing script in the current directory"

      param "COMPLINE", "The command to test completions for. This will be handled as if a TAB was pressed immediately at the end of it, so the last word is considered the active cursor. If you wish to complete for the next word instead, end your command with a space."

      environment_config_path
      environment_debug

      example %q[completely test "mygit pu"]
      example %q[completely test "mygit pull "]

      def run
        puts tester.test(compline).join "\n"
        if args['--keep']
          File.write 'completely-tester.sh', tester_script
          puts 'saved completely-tester.sh'
        end
      end

    private

      def compline
        args['COMPLINE']
      end

      def completions
        @completions ||= Completions.load config_path
      end

      def tester
        @tester ||= completions.tester
      end

      def tester_script
        @tester_script ||= tester.tester_script compline
      end

    end
  end
end
