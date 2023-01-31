lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'completely/version'

Gem::Specification.new do |s|
  s.name        = 'completely'
  s.version     = Completely::VERSION
  s.summary     = 'Bash Completions Generator'
  s.description = 'Generate bash completion scripts using simple YAML configuration'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ['completely']
  s.homepage    = 'https://github.com/dannyben/completely'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.7.0'

  s.add_runtime_dependency 'colsole', '>= 0.8.1', '< 2'
  s.add_runtime_dependency 'mister_bin', '~> 0.7'

  s.metadata['rubygems_mfa_required'] = 'true'
end
