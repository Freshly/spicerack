# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "directive/version"

Gem::Specification.new do |spec|
  spec.name          = "directive"
  spec.version       = Directive::VERSION
  spec.authors       = [ "Allen Rettberg" ]
  spec.email         = [ "allen.rettberg@freshly.com" ]

  spec.summary       = "Gem configuration made simple"
  spec.description   = "Easily create rich, self-documenting gem configuration"
  spec.homepage      = "https://github.com/Freshly/spicerack/tree/master/directive"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Freshly/spicerack/blob/master/directive"
  spec.metadata["changelog_uri"] = "https://github.com/Freshly/spicerack/blob/master/directive/CHANGELOG.md"

  spec.files         = Dir["README.md", "LICENSE.txt", ".yardopts", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", ">= 5.2.1"

  spec.add_development_dependency "bundler", ">= 2.0.1"
  spec.add_development_dependency "faker", ">= 1.8", "< 2.0"
  spec.add_development_dependency "pry", "~> 0.10.0"
  spec.add_development_dependency "pry-nav", ">= 0.2.4"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "shoulda-matchers", "4.0.1"
end
