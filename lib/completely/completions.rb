require 'yaml'
require 'erb'

module Completely
  class Completions
    attr_reader :config

    class << self
      def load(config_path)
        new YAML.load_file(config_path)
      end
    end

    def initialize(config)
      @config = config
    end

    def script
      ERB.new(template, trim_mode: '%-').result(binding)
    end

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
      @patterns ||= config[command]
    end

    def root_words
      @root_words ||= patterns.keys.map do |w|
        w.split(' ').first
      end.uniq.sort
    end

  end
end