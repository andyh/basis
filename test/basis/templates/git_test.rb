require "helper"

module Basis
  module Templates
    class GitTest < Test::Unit::TestCase
      def test_initialize_with_a_git_url
        t = Basis::Template.git("git://github.com/jbarnette/basis")
        assert_equal("git", t.url.scheme)
        assert_equal("github.com", t.url.host)
        assert_equal("/jbarnette/basis", t.url.path)
      end

      def test_initialize_with_a_shorthand_git_url
        t = Basis::Template.git("git@github.com:jbarnette/basis.git")
        assert_equal("ssh", t.url.scheme)
      end
      
      def test_initialize_with_a_raw_path
        flunk
      end
    end
  end
end
