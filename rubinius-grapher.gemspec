# coding: utf-8
require './lib/rubinius/grapher/version'

Gem::Specification.new do |spec|
  spec.name          = "rubinius-grapher"
  spec.version       = Rubinius::Grapher::VERSION
  spec.authors       = ["Brian Shirai"]
  spec.email         = ["brixen@gmail.com"]

  spec.summary       = %q{A tool to graph Rubinius metrics and diagnostics data.}
  spec.description   = %q{Rubinius provides built-in performance metrics and also writes diagnostics data to a log. This tool can process logged diagnostics and metric data written to a file to produce various graphs.}
  spec.homepage      = "https://github.com/rubinius/rubinius-grapher"
  spec.license       = "MPL-2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
