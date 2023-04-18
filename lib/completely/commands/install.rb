require 'completely/commands/base'

module Completely
  module Commands
    class Install < Base
      help 'Install a bash completion script'

      usage 'completely install PROGRAM [SCRIPT_PATH --force]'
      usage 'completely install (-h|--help)'

      option '-f --force', 'Overwrite target file if it exists'

      param 'PROGRAM', 'Name of the program the completions are for.'
      param 'SCRIPT_PATH', 'Path to the source bash script [default: completely.bash].'

      def run
        bounce
        success = system(*command)
        raise "Failed running command:\nnb`#{command.join ' '}`" unless success

        say "Saved m`#{target_path}`"
      end

    private

      def bounce
        unless completions_path
          raise 'Cannot determine system completions directory'
        end

        unless File.exist? script_path
          raise "Cannot find script: m`#{script_path}`"
        end

        if File.exist?(target_path) && !args['--force']
          raise "File exists: m`#{target_path}`\nUse nb`--force` to overwrite"
        end
      end

      def command
        result = root? ? [] : %w[sudo]
        result + %W[cp #{script_path} #{target_path}]
      end

      def script_path
        args['SCRIPT_PATH'] || 'completely.bash'
      end

      def target_path
        "#{completions_path}/#{args['PROGRAM']}"
      end

      def root?
        Process.uid.zero?
      end

      def completions_path
        @completions_path ||= completions_path!
      end

      def completions_path!
        candidates = %w[
          /usr/share/bash-completion/completions
          /usr/local/etc/bash_completion.d
        ]

        candidates.each do |candidate|
          return candidate if Dir.exist? candidate
        end

        nil
      end
    end
  end
end
