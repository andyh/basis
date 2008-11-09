require "helper"

module Basis
  class RepositoryTest < Test::Unit::TestCase
    def test_initialize_succeeds_with_a_valid_path
      valid = File.join(Dir.tmpdir, "repository")
      FileUtils.rm_rf(valid)
      FileUtils.mkdir_p(valid)
      
      repo = Basis::Repository.new(valid)
      assert_equal(Pathname.new(valid), repo.path)
    end
    
    def test_initiaized_explodes_on_bad_paths
      assert_raise(Basis::DirectoryNotFound) do
        Basis::Repository.new(File.join(Dir.tmpdir, "nonexistent"))
      end
    end
  end
end
