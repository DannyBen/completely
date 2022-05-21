require 'completely/commands/base'

module Completely
  module Commands
    class Generate < Base
      help "Generate the bash completion script to a file"

      usage "completely generate [CONFIG_PATH SCRIPT_PATH --function NAME --wrap NAME]"
      usage "completely generate (-h|--help)"

      option_function
      option "-w --wrap NAME", "Wrap the completion script inside a function that echos the script. This is useful if you wish to embed it directly in your script"

      param_config_path
      param "SCRIPT_PATH", "Path to the output bash script. When not provided, the name of the input file will be used with a .bash extension\nCan also be set by an environment variable"

      environment_config_path
      environment "COMPLETELY_SCRIPT_PATH", "Path to the output bash script"
      environment_debug

      def run
        wrap = args['--wrap']
        output = wrap ? wrapper_function(wrap) : script
        File.write script_path, output
        say "Saved !txtpur!#{script_path}"
        syntax_warning unless completions.valid?
      end

    private

      def wrapper_function(wrapper_name)
        completions.wrapper_function wrapper_name
      end

    end
  end
end
