require "helper"

module Basis
  class TemplateTest < Test::Unit::TestCase
    def setup
      path = Dir.tmpdir + "/repo"
      FileUtils.rm_rf path
      FileUtils.mkdir path
      
      @repo = Basis::Repository.new path
      @template = Basis::Template.new @repo, :type, "source", "name"
      FileUtils.cp_r FIXTURES_PATH + "/static", @template.cache
    end

    def test_initialize_takes_a_source      
      assert_equal "source", @template.source
    end

    def test_loads_config_if_available
      assert_equal "static!", @template.config["name"]
    end

    def test_has_empty_config_if_not_available
      t = Basis::Template.new @repo, :type, "nonexistent"
      assert_equal({}, t.config)
    end
  end
end
