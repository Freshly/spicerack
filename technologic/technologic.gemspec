
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "technologic/version"

Gem::Specification.new do |spec|
  spec.name          = "technologic"
  spec.version       = Technologic::VERSION
  spec.authors       = ["Eric Garside"]
  spec.email         = ["garside@gmail.com"]

  spec.summary       = "An approach for producing clear, terse, standardized, actionable, and data-rich logs."
  spec.description   = "An opinionated philosophy on logging for Ruby on Rails applications."
  spec.homepage      = "https://www.freshly.com"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", "~> 5.1.6"
end
