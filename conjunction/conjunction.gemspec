lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "conjunction/version"

Gem::Specification.new do |spec|
  spec.name          = "conjunction"
  spec.version       = Conjunction::VERSION
  spec.authors       = [ "Eric Garside" ]
  spec.email         = %w[garside@gmail.com]

  spec.summary       = "Provides a mechanism to loosely coupled a suite of cross-referenced objects"
  spec.description   = "Join together related concepts for a common purpose with Conjugation"
  spec.homepage      = "https://github.com/Freshly/spicerack/tree/master/conjunction"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/Freshly/spicerack/blob/master/conjunction/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/conjunction/#{Conjunction::VERSION}"

  spec.files         = Dir["README.md", "LICENSE.txt", ".yardopts", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", ">= 5.2.1"

  spec.add_runtime_dependency "spicerack", Conjunction::VERSION

  spec.add_dependency "activemodel", ">= 5.2.1"
end
