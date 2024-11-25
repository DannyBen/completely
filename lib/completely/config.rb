module Completely
  class Config
    attr_reader :config

    class << self
      def load(config_path)
        begin
          config = YAML.load_file config_path, aliases: true
        rescue ArgumentError
          # :nocov:
          config = YAML.load_file config_path
          # :nocov:
        end

        new config
      end
    end

    def initialize(config)
      @config = config
    end

    def flat_config
      result = {}

      config.each do |root_key, root_list|
        result.merge! process_key(root_key, root_list)
      end

      result
    end

  private

    def process_key(prefix, list)
      result = {}
      result[prefix] = collect_immediate_children list
      result.merge! process_nested_items(prefix, list)
      result
    end

    def collect_immediate_children(list)
      list.map do |item|
        x = item.is_a?(Hash) ? item.keys.first : item
        x.gsub(/^[*+]/, '')
      end
    end

    def process_nested_items(prefix, list)
      result = {}

      list.each do |item|
        next unless item.is_a? Hash

        nested_prefix = generate_nested_prefix(prefix, item)
        nested_list = item.values.first
        result.merge!(process_key(nested_prefix, nested_list))
      end

      result
    end

    def generate_nested_prefix(prefix, item)
      appended_prefix = item.keys.first.gsub(/^\+/, '*')
      appended_prefix = " #{appended_prefix}" unless appended_prefix.start_with? '*'
      "#{prefix}#{appended_prefix}"
    end
  end
end
