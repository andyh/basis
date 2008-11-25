require "helper"

module Basis
  class ConfigTest < Test::Unit::TestCase
    def test_can_read_from_a_file
      c = Config.new(FIXTURES_PATH + "/config.yml")
      assert_equal "Sparky Richmond", c["user.name"]
      assert_equal "sparky@example.org", c["user.email"]
    end
    
    def test_can_be_saved
      path = File.join Dir.tmpdir, "config.yml"
      first = Config.new(path)
      
      first["foo"] = "bar"
      first.save
      
      second = Config.new(path)
      assert_equal first["foo"], second["foo"]
    end
  end
end
