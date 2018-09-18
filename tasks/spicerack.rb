# frozen_string_literal: true

SPICERACK_GEMS = %w[around_the_world].freeze

root = File.expand_path("..", __dir__)
version = File.read("#{root}/SPICERACK_VERSION").strip

SPICERACK_GEMS.each do |gem|
  namespace gem do
    task :update_version do
      file_path = "#{root}/#{gem}/lib/#{gem}/version.rb"
      file_text = File.read(file_path)

      file_text.gsub!(%r{^(\s*)VERSION(\s*)= .*?$}, "\\1VERSION = \"#{version}\"")
      raise "Could not insert VERSION in #{file_path}" unless $1

      File.open(file_path, "w") { |f| f.write file_text }
    end
  end
end

namespace :spicerack do
  task :update_all_versions do
    SPICERACK_GEMS.each { |gem| Rake::Task["#{gem}:update_version"].execute }
  end

  task :release_all do
    SPICERACK_GEMS.each { |gem| sh "cd #{gem} && bundle exec rake release" }
    Rake::Task["release"].execute
  end
end