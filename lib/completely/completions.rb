require 'yaml'
require 'erb'

module Completely
  class Completions
    attr_reader :config, :function_name

    class << self
      def load(config_path, function_name: nil)
        new YAML.load_file(config_path), function_name: function_name
      end
    end

    def initialize(config, function_name: nil)
      @config, @function_name = config, function_name
    end

    def script
      ERB.new(template, trim_mode: '%-').result(binding)
    end

    def wrapper_function(name = nil)
      name ||= "send_completions"

      script_lines = script.split("\n").map do |line|
        clean_line = line.gsub("'") { "\\'" }
        %Q[  echo $'#{clean_line}']
      end.join("\n")

      "#{name}() {\n#{script_lines}\n}"
    end

  private

    def template_path
      @template_path ||= File.expand_path("template.erb", __dir__)
    end

    def template
      @template ||= File.read(template_path)
    end

    def command
      @command ||= config.keys.first
    end

    def patterns
      @patterns ||= config.to_a.sort_by { |k, v| -k.size }.to_h
    end

    def function_name
      @function_name ||= "_#{command}_completions"
    end

  end
end