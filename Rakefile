# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

def rbs_target
  [
    "sig/",
    File.basename(Dir.glob("*.gemspec").first, ".gemspec"),
    ".rbs"
  ].join
end

Rake::TestTask.new(:spec) do |t|
  t.libs << "spec"
  t.libs << "lib"
  t.test_files = FileList["spec/**/*_spec.rb"]
end

require "standard/rake"

namespace :sig do
  desc "generate RBS signatures"
  task :generate => :concat_codes do # rubocop:disable Style/HashSyntax
    sh "sord --rbs #{rbs_target}"
  end

  desc "concat codes"
  task :concat_codes do
    FileUtils.mkdir_p("sig")
    File.open(rbs_target, "w") { |w|
      w.puts Dir.glob("lib/**/*.rb").map { |r|
        File.read(r)
      }.join("\n")
    }
  end
end

task default: %i[spec standard]
