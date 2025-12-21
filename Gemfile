# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in jekyll-kroki-tag.gemspec
gemspec

gem "rake", "~> 13.0"

gem "jekyll", "~> 4.3"

gem "solargraph", "~> 0.49.0"

gem "rubocop", "~> 1.62"
gem "standard", "~> 1.37"

gem "sord"

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4")
  gem "abbrev"
end

group :test do
  gem "minitest", "~> 5.0"
  gem "power_assert", "< 3"
  gem "minitest-power_assert", "~> 0.3.1"
  gem "minitest-reporters", "~> 1.6"
end
