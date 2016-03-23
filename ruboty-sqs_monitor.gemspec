# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/sqs_monitor/version'

Gem::Specification.new do |spec|
  spec.name          = "ruboty-sqs_monitor"
  spec.version       = Ruboty::SqsMonitor::VERSION
  spec.authors       = ["arukoh"]
  spec.email         = ["arukoh10@gmail.com"]

  spec.summary       = %q{Monitor AWS SQS via Ruboty.}
  spec.description   = %q{Monitor AWS SQS via Ruboty.}
  spec.homepage      = "https://github.com/arukoh/ruboty-sqs_monitor"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "ruboty"
  spec.add_dependency "aws-sdk"
end
