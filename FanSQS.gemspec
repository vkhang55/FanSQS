# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'FanSQS/version'

Gem::Specification.new do |spec|
  spec.name          = "FanSQS"
  spec.version       = FanSQS::VERSION
  spec.authors       = ["Khang Pham"]
  spec.email         = ["vkhang55@gmail.com"]
  spec.summary       = %q{Distributed messages queuing system using AWS SQS}
  spec.description   = %q{Distributed messages queuing system using AWS SQS}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rake"
  spec.add_dependency "aws-sdk", "~> 1.41.0"

  # For testing
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency 'pry'
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'rspec-mocks'
  spec.add_development_dependency 'shoulda-matchers'
end
