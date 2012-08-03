require File.expand_path("../lib/da-suspenders/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'da-suspenders'
  s.version     = DaSuspenders::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["thoughtbot", "Stefan Daschek"]
  s.email       = 'stefan@die-antwort.eu'
  s.homepage    = 'http://github.com/die-antwort/da-suspenders'
  s.summary     = "Generate a Rails app using DIE ANTWORT's best practices."
  s.description = "DIE ANTWORT's fork of thoughtbot's original Suspenders. Suspenders is an upgradeable base Rails project."

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency('rails', '3.2.6')
  s.add_dependency('bundler', '>= 1.0.10')
  s.add_dependency('trout', '~> 0.3')

  s.add_development_dependency('rake', '~> 0.9.2')
  s.add_development_dependency('rspec', '~> 2.11.0')
  
  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.test_files   = s.files.select{ |path| path =~ /^features/ }
  s.require_path = 'lib'

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md LICENSE]
end
