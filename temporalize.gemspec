# frozen_string_literal: true

require_relative "lib/temporalize/version"

Gem::Specification.new do |spec|
  spec.name = "temporalize"
  spec.version = Temporalize::VERSION
  spec.authors = ["pacMakaveli"]
  spec.email = ["pacMakaveli90@gmail.com"]

  spec.summary       = "Handles attributes representing durations in seconds."
  spec.description   = "Provides a convenient way to work with attributes that store durations in seconds, allowing for custom formatting and column names."
  spec.homepage      = "https://github.com/yourusername/temporalize" # Replace with your repo
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html

  spec.add_dependency "base64"
  spec.add_dependency "bigdecimal"
  spec.add_dependency "logger"
  spec.add_dependency "mutex_m"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.16"
  spec.add_development_dependency "rubocop", "~> 1.21"
  spec.add_development_dependency "activerecord", "~> 6.0"
  spec.add_development_dependency "activesupport", "~> 6.0"
  spec.add_development_dependency "sqlite3", "~> 1.4"


end
