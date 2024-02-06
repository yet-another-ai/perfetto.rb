# frozen_string_literal: true

require "bundler/gem_tasks"

require "rake/extensiontask"
gemspec = Gem::Specification.load("perfetto.gemspec")
Rake::ExtensionTask.new("perfetto_native", gemspec) do |ext|
  ext.ext_dir = "ext/perfetto"
  ext.lib_dir = "lib/perfetto"
end

require "minitest/test_task"
Minitest::TestTask.create

require "rubocop/rake_task"
RuboCop::RakeTask.new

task default: %i[test rubocop]
