require 'completely/commands/base'

module Completely
  module Commands
    class Uninstall < Base
      summary 'Uninstall a bash completion script'

      help <<~HELP
        This command will remove the completion script for the specified program from all the bash completion directories.
      HELP

      usage 'completely uninstall PROGRAM [--dry]'
      usage 'completely uninstall (-h|--help)'

      option '-d --dry', 'Show the uninstallation command but do not run it'

      param 'PROGRAM', 'Name of the program the completions are for.'

      def run
        if args['--dry']
          puts installer.uninstall_command_string
          return
        end

        success = installer.uninstall
        raise InstallError, "Failed running command:\nnb`#{installer.uninstall_command_string}`" unless success

        say 'Done'
        say 'You may need to restart your session to test it'
      end

    private

      def installer
        Installer.new program: args['PROGRAM']
      end
    end
  end
end
