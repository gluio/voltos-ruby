# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'voltos/version'

Gem::Specification.new do |spec|
  spec.name          = "voltos"
  spec.version       = Voltos::VERSION
  spec.authors       = ["Daniel May"]
  spec.email         = ["daniel@thedanielmay.com"]

  spec.summary       = %q{Access Voltos API}
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "http://rubygems.org/gems/voltos"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.extensions    = %w[ext/extconf.rb]
  spec.executables   = ['voltos']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  # spec.add_development_dependency "curb", '~> 0'
  # spec.add_development_dependency "json", '~> 1.8.3'
  spec.add_development_dependency 'json', '~> 1.8', '>= 1.8.3'
  spec.add_development_dependency 'byebug', '> 0'

  # spec.add_development_dependency "bundler"
  # spec.add_development_dependency "rake"
  # spec.add_development_dependency "rspec"
  # spec.add_development_dependency 'curb', '~> 0'
  # spec.add_development_dependency "json"

  spec.add_runtime_dependency "curb", [">= 0"]
  spec.add_runtime_dependency "rubyzip", [">= 0"]
  # spec.add_runtime_dependency "json", [">= 0"]
  # add_runtime_dependency 'curb', '>= 0', '~> 0'
end
