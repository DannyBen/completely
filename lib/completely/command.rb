module Completely
  class Command < MisterBin::Command
    help "Bash completion script generator"
    version Completely::VERSION

    usage "completely new [CONFIG_PATH]"
    usage "completely preview [CONFIG_PATH --function NAME]"
    usage "completely generate [CONFIG_PATH OUTPUT_PATH --function NAME --wrap NAME]"
    usage "completely (-h|--help|--version)"

    command "new", "Create a new sample YAML configuration file"
    command "preview", "Generate the bash completion script to STDOUT"
    command "generate", "Generate the bash completion script to a file"

    option "-f --function NAME", "Modify the name of the function in the generated script"
    option "-w --wrap NAME", "Wrap the completion script inside a function that echos the script. This is useful if you wish to embed it directly in your script"

    param "CONFIG_PATH", "Path to the YAML configuration file"
    param "OUTPUT_PATH", "Path to the output bash script"

    example "completely new"
    example "completely new input.yaml"
    example "completely preview --function _my_completions"
    example "completely generate"
    example "completely generate input.yaml"
    example "completely generate input.yaml output.sh -f _my_completions"
    example "completely generate -w give_comps -f my_completions"

    def new_command
      if File.exist? config_path
        raise "File already exists: #{config_path}"
      else
        File.write config_path, sample
        say "Saved !txtpur!#{config_path}"
      end
    end

    def preview_command
      puts script
    end
    
    def generate_command
      wrap = args['--wrap']
      output = wrap ? wrapper_function(wrap) : script
      File.write output_path, output
      say "Saved !txtpur!#{output_path}"
    end

  private

    def config_path
      @config_path ||= args['CONFIG_PATH'] || "completely.yaml"
    end

    def output_path
      @output_path ||= args['OUTPUT_PATH'] || "completely.bash"
    end

    def sample
      @sample ||= File.read(sample_path)
    end

    def sample_path
      @sample_path ||= File.expand_path("sample.yaml", __dir__)
    end

    def script
      @script ||= completions.script
    end

    def wrapper_function(wrapper_name)
      completions.wrapper_function wrapper_name
    end

    def completions
      @completions ||= Completions.load(config_path, function_name: args['--function'])
    end

  end
end
