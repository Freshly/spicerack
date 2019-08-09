lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "collectible/version"

Gem::Specification.new do |spec|
  spec.name          = "collectible"
  spec.version       = Collectible::VERSION
  spec.authors       = [ "Allen Rettberg", "Eric Garside" ]
  spec.email         = %w[allen.rettberg@freshly.com eric.garside@freshly.com]

  spec.summary       = "Provides an extensible framework for building array-like object collections"
  spec.description   = "Perform operations on and pass around explicit collections of objects"
  spec.homepage      = "https://github.com/Freshly/spicerack/tree/master/collectible"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/Freshly/spicerack/blob/master/collectible/CHANGELOG.md"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", "~> 5.2.1"
  spec.add_runtime_dependency "short_circu_it", Collectible::VERSION
  spec.add_runtime_dependency "tablesalt", Collectible::VERSION
end
