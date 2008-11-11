require "rubygems"
require "hoe"

require "./lib/basis/version.rb"

Hoe.new("basis", Basis::VERSION) do |p|
  p.developer "John Barnette", "jbarnette@rubyforge.org"
  p.test_globs = ["test/**/*_test.rb"]

  p.extra_deps << ["erubis", "~> 2.6"]
  p.extra_deps << ["thor", "~> 0.9"]
end

desc "Create ctags"
task :ctags do
  sh "ctags --extra=+f -R lib test"
end

