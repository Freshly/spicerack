
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "golgi/version"

Gem::Specification.new do |spec|
  spec.name          = "golgi"
  spec.version       = Golgi::VERSION
  spec.authors       = ["Eric Garside"]
  spec.email         = ["garside@gmail.com"]

  spec.summary       = "Securely serialize and deserialize any objects, using GlobalID where appropriate"
  spec.description   = "General purpose, GlobalID Aware, secure object serialization and deserialization"
  spec.homepage      = "https://www.freshly.com"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", "~> 5.2.1"
  spec.add_runtime_dependency "railties", "~> 5.2.1"
end
