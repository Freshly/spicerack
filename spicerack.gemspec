version = File.read(File.expand_path("SPICERACK_VERSION", __dir__)).strip

Gem::Specification.new do |spec|
  spec.name          = "spicerack"
  spec.version       = version
  spec.authors       = ["Eric Garside", "Allen Rettberg"]
  spec.email         = %w[garside@gmail.com allen.rettberg@freshly.com]

  spec.summary       = "A suite of utility gems for Ruby on Rails."
  spec.description   = "This collection of gems will spice up your rails and kick your rubies up a notch. Bam!"
  spec.homepage      = "https://www.freshly.com/"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  # Spicerack Gems
  spec.add_dependency "around_the_world", version
  spec.add_dependency "short_circu_it", version
  spec.add_dependency "hall_monitor", version
  spec.add_dependency "technologic", version
  spec.add_dependency "table_salt", version

  spec.add_development_dependency "bundler", "~> 2.0.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.16"
  spec.add_development_dependency "faker", "~> 1.8"
  spec.add_development_dependency "pry", "~> 0.10.0"
  spec.add_development_dependency "pry-nav", ">= 0.2.4"

  # Spicerack Development Gems
  spec.add_development_dependency "rspice", version
  spec.add_development_dependency "spicerack-styleguide", version
end
