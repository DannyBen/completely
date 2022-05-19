require 'completely/commands/base'

module Completely
  module Commands
    class Generate < Base
      help "Generate the bash completion script to a file"

      usage "completely generate [CONFIG_PATH OUTPUT_PATH --function NAME --wrap NAME]"
      usage "completely generate (-h|--help)"

      function_usage
      option "-w --wrap NAME", "Wrap the completion script inside a function that echos the script. This is useful if you wish to embed it directly in your script"

      config_path_usage
      param "OUTPUT_PATH", "Path to the output bash script [default: completely.bash]"

      def run
        wrap = args['--wrap']
        output = wrap ? wrapper_function(wrap) : script
        File.write output_path, output
        say "Saved !txtpur!#{output_path}"
        syntax_warning unless completions.valid?
      end

    private

      def wrapper_function(wrapper_name)
        completions.wrapper_function wrapper_name
      end

      def output_path
        @output_path ||= args['OUTPUT_PATH'] || "completely.bash"
      end

    end
  end
end
