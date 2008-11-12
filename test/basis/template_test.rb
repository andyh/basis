require "helper"

module Basis
  class TemplateTest < Test::Unit::TestCase
    def test_initialize_takes_a_source
      t = Basis::Template.new(nil, "source")
      assert_equal("source", t.source)
    end
  end
end

