
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "redis_hash/version"

Gem::Specification.new do |spec|
  spec.name          = "redis_hash"
  spec.version       = RedisHash::VERSION
  spec.authors       = ["Eric Garside"]
  spec.email         = ["garside@gmail.com"]

  spec.summary       = "Provides a class that matches the Hash api by wrapping Redis"
  spec.description   = "A full implementation of Ruby's Hash API which transparently wraps a Redis hash"
  spec.homepage      = "https://github.com/Freshly/spicerack/tree/master/redis_hash"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", "~> 5.2.1"
  spec.add_runtime_dependency "redis", "~> 4.0"
end