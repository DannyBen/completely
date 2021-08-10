module Completely
  class Pattern
    attr_reader :text, :completions

    def initialize(text, completions)
      @text = text
      @completions = completions || []
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

    def compgen
      @compgen ||= compgen!
    end

  private

    def compgen!
      result = []
      result << %Q[#{actions.join ' '}] if actions.any?
      result << %Q[-W "#{words.join ' '}"] if words.any?
      result.any? ? result.join(' ') : nil
    end
  end
end