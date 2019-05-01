lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "callforth/version"

Gem::Specification.new do |spec|
  spec.name          = "callforth"
  spec.version       = Callforth::VERSION
  spec.authors       = ["Eric Garside"]
  spec.email         = ["garside@gmail.com"]

  spec.summary       = "allows you to call, with data, any class or instance methods"
  spec.description   = "Like a callback, except from an outside caller rather than a bound listener"
  spec.homepage      = "https://www.freshly.com"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"
end