# frozen_string_literal: true

require_relative "lib/subsequent/version"

Gem::Specification.new do |spec|
  spec.name = "subsequent"
  spec.version = Subsequent::VERSION
  spec.authors = ["Robert Fletcher"]
  spec.email = ["lobatifricha@gmail.com"]

  spec.summary = "A simple CLI todo app that interfaces with Trello"
  spec.homepage = "https://github.com/mockdeep/subsequent"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files =
    Dir.chdir(__dir__) do
      `git ls-files -z`.split("\x0").reject do |f|
        (File.expand_path(f) == __FILE__) ||
          f.start_with?("bin/", "spec/", ".git", ".github", "Gemfile")
      end
    end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency("activesupport", "~> 8.0")
  spec.add_dependency("http", "~> 5.2")
  spec.metadata["rubygems_mfa_required"] = "true"
end
