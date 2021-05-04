# frozen_string_literal: true

require_relative "lib/substance/version"

rails_version = File.read(File.expand_path("../RAILS_VERSION", __dir__)).strip

Gem::Specification.new do |spec|
  spec.name          = "substance"
  spec.version       = Substance::VERSION
  spec.authors       = [ "Freshly Engineering" ]
  spec.email         = %w[eng@freshly.com]

  spec.summary       = "Base classes for building powerful service objects"
  spec.description   = "Base classes for building powerful service objects"
  spec.homepage      = "https://github.com/Freshly/spicerack/blob/main/substance"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Freshly/spicerack/blob/main/substance"
  spec.metadata["changelog_uri"] = "https://github.com/Freshly/spicerack/blob/main/substance/CHANGELOG.md"

  spec.files         = Dir["README.md", "LICENSE.txt", ".yardopts", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = %w[lib]

  spec.add_runtime_dependency "activemodel", rails_version
  spec.add_runtime_dependency "activesupport", rails_version
  spec.add_runtime_dependency "short_circu_it", Substance::VERSION
  spec.add_runtime_dependency "tablesalt", Substance::VERSION
  spec.add_runtime_dependency "technologic", Substance::VERSION

  spec.add_development_dependency "faker", ">= 1.8", "< 2.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "bundler", ">= 2.0.1"
  spec.add_development_dependency "pry", "~> 0.10.0"
  spec.add_development_dependency "pry-nav", ">= 0.2.4"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "shoulda-matchers", "4.0.1"
end
