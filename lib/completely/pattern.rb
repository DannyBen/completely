module Completely
  class Pattern
    attr_reader :text, :completions, :function_name

    def initialize(text, completions, function_name)
      @text = text
      @completions = completions || []
      @function_name = function_name
    end

    def length
      @length ||= text.size
    end

    def empty?
      completions.empty?
    end

    def words
      @words ||= completions.reject { |w| w =~ /^<.*>$/ }
    end

    def actions
      @actions ||= completions.filter_map do |word|
        action = word[/^<(.+)>$/, 1]
        "-A #{action}" if action
      end
    end

    def prefix
      text.split(' ')[0]
    end

    def case_string
      if text_without_prefix.empty?
        "*"
      elsif text_without_prefix.include? "*" 
        %Q['#{text_without_prefix.gsub "*", "'*'"}']
      else
        %Q['#{text_without_prefix}'*]
      end
    end

    def text_without_prefix
      @text_without_prefix ||= text.split(' ')[1..-1].join ' '
    end

    def compgen
      @compgen ||= compgen!
    end

  private

    def compgen!
      result = []
      result << %Q[#{actions.join ' '}] if actions.any?
      result << %Q[-W "$(#{function_name} "#{words.join ' '}")"] if words.any?
      result.any? ? result.join(' ') : nil
    end
  end
end