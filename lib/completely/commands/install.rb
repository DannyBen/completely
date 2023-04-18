require 'completely/commands/base'

module Completely
  module Commands
    class Install < Base
      TARGETS = %W[
        /usr/share/bash-completion/completions
        /usr/local/etc/bash_completion.d
        #{Dir.home}/.bash_completion.d
      ]

      summary 'Install a bash completion script'

      help <<~HELP
        This command will copy the specified file to one of the following directories:

        #{TARGETS.map { |c| "  - #{c}" }.join "\n"}

        The target filename will be the program name, and sudo will be used if necessary.
      HELP

      usage 'completely install PROGRAM [SCRIPT_PATH --force --dry]'
      usage 'completely install (-h|--help)'

      option '-f --force', 'Overwrite target file if it exists'
      option '-d --dry', 'Show the installation command but do not run it'

      param 'PROGRAM', 'Name of the program the completions are for.'
      param 'SCRIPT_PATH', 'Path to the source bash script [default: completely.bash].'

      def run
        bounce

        if args['--dry']
          puts command.join ' '
          return
        end

        success = system(*command)
        raise "Failed running command:\nnb`#{command.join ' '}`" unless success

        say "Saved m`#{target_path}`"
        say 'You may need to restart your session to test it'
      end

    private

      def bounce
        unless completions_path
          raise 'Cannot determine system completions directory'
        end

        unless File.exist? script_path
          raise "Cannot find script: m`#{script_path}`"
        end

        if target_exist? && !args['--force']
          raise "File exists: m`#{target_path}`\nUse nb`--force` to overwrite"
        end
      end

      def target_exist?
        File.exist? target_path
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
        TARGETS.each do |tarnet|
          return tarnet if Dir.exist? tarnet
        end

        nil
      end
    end
  end
end
