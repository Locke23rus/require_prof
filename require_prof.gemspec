# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'require_prof/version'

Gem::Specification.new do |spec|
  spec.name          = "require_prof"
  spec.version       = RequireProf::VERSION
  spec.authors       = ["Kirill Nikitin"]
  spec.email         = ["locke23rus@gmail.com"]

  spec.summary       = %q{Simple require profiler}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/Locke23rus/require_prof"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "text-table", "~> 1.2"
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.5"
end
