# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record/remote/version'

Gem::Specification.new do |spec|
  spec.name          = "active_record-remote"
  spec.version       = ActiveRecord::Remote::VERSION
  spec.authors       = ["Justin Grubbs"]
  spec.email         = ["justin@jgrubbs.net"]
  spec.summary       = %q{Active Record pattern for remote APIs}
  spec.description   = %q{Active Record pattern for remote APIs}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "virtus",        "~> 1.0.5"
  spec.add_dependency "activesupport", "~> 4.2.5"
  spec.add_dependency "builder",       "~> 3.2.2"
  spec.add_dependency "activemodel",   "~> 4.2.5"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end