# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "jekyll"
require "jekyll/kroki_tag"

require "minitest-power_assert"
require "minitest/reporters"
require "minitest/autorun"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
