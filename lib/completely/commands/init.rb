require 'completely/commands/base'

module Completely
  module Commands
    class Init < Base
      help "Create a new sample YAML configuration file"

      usage "completely init [CONFIG_PATH]"
      usage "completely init (-h|--help)"

      param_config_path
      environment_config_path

      def run
        if File.exist? config_path
          raise "File already exists: #{config_path}"
        else
          File.write config_path, sample
          say "Saved !txtpur!#{config_path}"
        end
      end

    private

      def sample
        @sample ||= File.read sample_path
      end

      def sample_path
        @sample_path ||= File.expand_path "../templates/sample.yaml", __dir__
      end

    end
  end
end
