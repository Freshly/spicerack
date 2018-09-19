lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "around_the_world/version"

Gem::Specification.new do |spec|
  spec.name          = "around_the_world"
  spec.version       = AroundTheWorld::VERSION
  spec.authors       = ["Allen Rettberg"]
  spec.email         = ["allen.rettberg@freshly.com"]

  spec.summary       = "A metaprogramming module which allows you to wrap any method easily."
  spec.description   = "Why metaprogram like a chump when you can do it like a champ!"
  spec.homepage      = "https://www.freshly.com"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", "~> 5.1.6"
end
