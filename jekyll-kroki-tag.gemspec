# frozen_string_literal: true

require_relative "lib/jekyll/kroki_tag/version"

Gem::Specification.new do |spec|
  spec.name = "jekyll-kroki-tag"
  spec.version = Jekyll::KrokiTag::VERSION
  spec.authors = ["wtnabe"]
  spec.email = ["18510+wtnabe@users.noreply.github.com"]

  spec.summary = "text-to-diagram power to Jekyll with kroki.io"
  spec.homepage = "https://github.com/wtnabe/jekyll-kroki-tag"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "liquid", "~> 4"
  spec.add_dependency "parser", "~> 3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html

  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.3.0")
    spec.add_dependency "uri"
  end
end
