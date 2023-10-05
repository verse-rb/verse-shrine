# frozen_string_literal: true

require_relative "lib/verse/shrine/version"

Gem::Specification.new do |spec|
  spec.name = "verse-shrine"
  spec.version = Verse::Shrine::VERSION
  spec.authors = ["Yacine"]
  spec.email = ["yacine.petitprez@oivan.com"]

  spec.summary = "Shrine integration for Verse Framework."
  spec.description = "Shrine integration for Verse Framework."
  spec.homepage = "https://github.com/verse-rb/verse-shrine"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = ""

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/verse-rb/verse-shrine"
  spec.metadata["changelog_uri"] = "https://github.com/verse-rb/verse-shrine"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "shrine", "~> 3.5"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
