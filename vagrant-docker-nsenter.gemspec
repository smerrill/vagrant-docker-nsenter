# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-docker-nsenter/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-docker-nsenter"
  spec.version       = VagrantPlugins::DockerNSEnter::VERSION
  spec.authors       = ["Steven Merrill"]
  spec.email         = ["steven.merrill@gmail.com"]
  spec.summary       = %q{A way to attach to Vagrant-managed Docker containers.}
  spec.description   = %q{The docker-nsenter plugin allows you to use the nsenter binary on your host or the Vagrant proxy VM to run commands or get a shell in Vagrant-managed Docker containers.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
