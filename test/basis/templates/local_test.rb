require "helper"

module Basis
  module Templates
    class LocalTest < Test::Unit::TestCase
      def test_complains_about_nonexistent_source_directories
        assert_raise Basis::DirectoryNotFound do
          Basis::Templates::Local.new(nil, :local, Dir.tmpdir + "/nonexistent")
        end
      end
    end
  end
end
