require 'mister_bin'

module Completely
  module Commands
    class Base < MisterBin::Command

      class << self
        def config_path_usage
          param "CONFIG_PATH", "Path to the YAML configuration file [default: completely.yaml]"
        end

        def function_usage
          option "-f --function NAME", "Modify the name of the function in the generated script"
        end
      end

    protected

      def script
        @script ||= completions.script
      end

      def completions
        @completions ||= Completions.load(config_path, function_name: args['--function'])
      end

      def config_path
        args['CONFIG_PATH'] || 'completely.yaml'
      end

      def syntax_warning
        say! "\n!txtred!WARNING:\nYour configuration is invalid."
        say! "!txtred!All patterns must start with the same word."
      end
    end
  end
end
