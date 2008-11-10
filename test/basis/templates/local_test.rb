require "helper"

module Basis
  module Templates
    class LocalTest < Test::Unit::TestCase
      def test_initialize_local
        temp = Dir.tmpdir
        t = Basis::Template.local(temp)
        assert(t.url.to_s.include?(temp), "paths work")
        assert_equal("file", t.url.scheme)
      end
    end
  end
end
