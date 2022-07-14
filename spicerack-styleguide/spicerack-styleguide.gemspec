# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "spicerack/styleguide/version"

Gem::Specification.new do |spec|
  spec.name          = "spicerack-styleguide"
  spec.version       = Spicerack::Styleguide::VERSION
  spec.authors       = [ "Allen Rettberg" ]
  spec.email         = [ "allen.rettberg@freshly.com" ]

  spec.summary       = "Rubocop Styleguide for Rails and RSpec."
  spec.description   = "Wanna write code the Freshly way? Inherit this gem in your rubocop.yml and keep your code fresh"
  spec.homepage      = "https://github.com/Freshly/spicerack/tree/main/spicerack-styleguide"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/Freshly/spicerack/blob/main/spicerack-styleguide/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/spicerack-styleguide/#{Spicerack::Styleguide::VERSION}"

  spec.files         = Dir["rubocop.yml", "README.md", "LICENSE.txt", ".yardopts", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_dependency "rubocop", "~> 1.31.0"
  spec.add_dependency "rubocop-rspec", "~> 2.12.0"
  spec.add_dependency "rubocop-performance", "~> 1.14.0"
  spec.add_dependency "rubocop-rails", "~> 2.15.0"
end
