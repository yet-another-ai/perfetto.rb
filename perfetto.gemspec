# frozen_string_literal: true

require_relative "lib/perfetto/version"

Gem::Specification.new do |spec|
  spec.name = "perfetto"
  spec.version = Perfetto::VERSION
  spec.authors = ["Kowalski Dark"]
  spec.email = ["github@akenonet.com"]

  spec.summary = "Yet another event tracing library for Ruby."
  spec.description = "Yet another event tracing library for Ruby."
  spec.homepage = "https://github.com/yet-another-ai/perfetto.rb"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "ext"]
  spec.extensions = ["ext/perfetto/extconf.rb"]

  spec.add_development_dependency "minitest", "~> 5.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rake-compiler", "~> 1.1"
  spec.add_development_dependency "rubocop", "~> 1.21"
  spec.add_development_dependency "rubocop-rake", "~> 0.5"
  spec.add_development_dependency "rubocop-minitest", "~> 0.34"


  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
