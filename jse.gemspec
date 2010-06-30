lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'jse/version'

Gem::Specification.new do |s|
  s.name        = "jse"
  s.version     = JSE::VERSION
  s.platform    = Gem::Platform::RUBY
  s.author      = "Ryan Burrows"
  s.email       = "rhburrows@gmail.com"
  s.homepage    = "http://github.com/rhburrows/jse"
  s.summary     = "Stream editor for JSON streams"
  s.description = <<-DESC
    JsonStreamEditor allows manipulation of streams of json
  DESC

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "json"

  s.add_development_dependency "rspec"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "fakefs"

  s.files = File.readlines("Manifest.txt").inject([]) do |files, line|
    files << line.chomp
  end
  s.executables  = ['jse']
  s.require_path = 'lib'
end
