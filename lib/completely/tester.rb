require 'erb'
require 'tempfile'

module Completely
  class Tester
    attr_reader :script, :script_path, :function_name, :cword, :compline

    def initialize(script: nil, script_path: nil, function_name: )
      @script, @script_path, @function_name = script, script_path, function_name
    end

    def test(compline)
      Tempfile.create "completely-tester" do |f|
        f << tester_script(compline)
        f.flush
        `bash #{f.path}`
      end.split "\n"
    end

    def tester_script(compline)
      set_compline_vars compline
      ERB.new(template, trim_mode: '%-').result(binding)
    end

  protected

    def set_compline_vars(compline)
      @compline = compline
      @cword = compline.split(' ').size - 1
      @cword += 1 if compline.end_with? ' '
    end

    def absolute_script_path
      @absolute_script_path ||= begin
        script_path ? File.expand_path(script_path) : nil
      end
    end

    def template_path
      @template_path ||= File.expand_path "templates/tester-template.erb", __dir__
    end

    def template
      @template ||= File.read template_path
    end

  end
end