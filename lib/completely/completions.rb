require 'yaml'
require 'erb'

module Completely
  class Completions
    attr_reader :config, :function_name

    class << self
      def load(config_path, function_name: nil)
        begin
          data = YAML.load_file config_path, aliases: true
        rescue ArgumentError
          # :nocov:
          data = YAML.load_file config_path
          # :nocov:
        end
        
        new data, function_name: function_name
      end
    end

    def initialize(config, function_name: nil)
      @config, @function_name = config, function_name
    end

    def patterns
      @patterns ||= patterns!
    end

    def valid?
      pattern_prefixes.uniq.count == 1
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

    def tester
      @tester ||= Tester.new script: script, function_name: function_name
    end

  private

    def patterns!
      config.map do |text, completions|
        Pattern.new text, completions, pattern_function_name
      end.sort_by { |pattern| -pattern.length }
    end

    def template_path
      @template_path ||= File.expand_path("templates/template.erb", __dir__)
    end

    def template
      @template ||= File.read(template_path)
    end

    def command
      @command ||= config.keys.first.split(' ').first
    end

    def function_name
      @function_name ||= "_#{command}_completions"
    end

    def pattern_function_name
      @pattern_function_name ||= "#{function_name}_filter"
    end

    def pattern_prefixes
      patterns.map &:prefix
    end

  end
end