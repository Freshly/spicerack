# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

require_relative "shared/rakefile"

SPICERACK_GEMS = %w[
  around_the_world
  collectible
  redis_hash
  rspice
  short_circu_it
  spicerack-styleguide
  technologic
  tablesalt
].freeze
ALL_GEMS = %w[spicerack] + SPICERACK_GEMS

version = File.read("#{__dir__}/SPICERACK_VERSION").strip

ALL_GEMS.each do |gem|
  namespace gem do
    task :update_version do
      version_path = File.join(__dir__, (gem == "spicerack") ? "" : gem, "lib", gem.gsub("-", "/"), "version.rb")
      file_text = File.read(version_path)

      file_text.gsub!(%r{^(\s*)VERSION(\s*)= .*?$}, "\\1VERSION = \"#{version}\"")
      raise StandardError, "Could not insert VERSION in #{version_path}" unless $1

      File.open(version_path, "w") { |f| f.write file_text }
    end
  end
end

namespace :spicerack do
  task :yank_release, %i[version] do |_, arguments|
    version = arguments[:version] or raise ArgumentError, "version is required"
    SPICERACK_GEMS.each { |gem| sh "gem yank #{gem} -v #{version}" }
  end

  task :update_all_versions do
    ALL_GEMS.each { |gem| Rake::Task["#{gem}:update_version"].invoke }
    system "bundle"
  end

  task :release_all do
    Rake::Task["release"].invoke
    SPICERACK_GEMS.each { |gem| sh "cd #{gem} && bundle exec rake release" }
  end
end
