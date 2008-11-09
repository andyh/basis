require "helper"

module Basis
  class InstallerTest < Test::Unit::TestCase
    def setup
      @static = Pathname.new(File.join(FIXTURES_PATH, "static"))
      @target = Pathname.new(File.join(Dir.tmpdir, "destination"))
    
      FileUtils.rm_rf(@target)

      @installer = Basis::Installer.new(@static, @target)
      
      @dynamic = Pathname.new(File.join(FIXTURES_PATH, "dynamic"))
      @erb = Pathname.new(File.join(FIXTURES_PATH, "erb"))
      @lifecycle = Pathname.new(File.join(FIXTURES_PATH, "lifecycle"))
      
      @dynamic_installer = Basis::Installer.new(@dynamic, @target)
      @erb_installer = Basis::Installer.new(@erb, @target)
      @lifecycle_installer = Basis::Installer.new(@lifecycle, @target)
    end
    
    def test_initialize_takes_a_source_and_a_target
      assert_equal(@static, @installer.source)
      assert_equal(@target, @installer.target)
    end
    
    def test_initialize_explodes_on_nonexistent_sources
      assert_raise(Basis::DirectoryNotFound) do
        Basis::Installer.new("nonexistent", @target)
      end
    end
    
    def assert_file_exists(path)
      assert(Pathname.new(path).exist?, "#{path} exists")
    end

    def assert_file_does_not_exist(path)
      assert(!Pathname.new(path).exist?, "#{path} doesn't exist")
    end
    
    def assert_file_contents_equal(expected, path)
      assert_equal(expected, Pathname.new(path).read)
    end

    def valid_context
      { :greeting => "hai!", :foo => Struct.new(:bar).new("baz") } 
    end
    
    def test_install_copies_files
      @installer.install
      assert_file_exists(@target + "monkeys.txt")
    end
    
    def test_install_interpolates_simple__vars
      @dynamic_installer.install(:file => "foo")
      assert_file_exists(@target + "foo.txt")
    end

    def test_install_interpolates_nested_hash_keys
      @dynamic_installer.install(:complex => {:nested => {:value => "foo"}})
      assert_file_exists(@target + "foo.txt")
    end

    def test_install_interpolates_nested_method_calls
      nested = Struct.new(:value).new("foo")
      @dynamic_installer.install(:complex => {:nested => nested})
      assert_file_exists(@target + "foo.txt")
    end

    def test_install_interpolates_nested_keys_in_directory_names
      @dynamic_installer.install(:directory => "foo")
      assert_file_exists(@target + "foo/blank.txt")
    end

    def test_install_preserves_invalid_interpolations
      @dynamic_installer.install
      assert_file_exists(@target + "[invalid-].txt")
    end
    
    def test_install_preserves_missing_interpolations
      @dynamic_installer.install(Object.new)
      assert_file_exists(@target + "[file].txt")
    end
    
    def test_install_renders_files_with_erb_in_them
      @erb_installer.install(valid_context)
      assert_file_contents_equal("hai!", @target + "simple.txt")
    end

    def test_install_provides_the_context_to_erb_files
      @erb_installer.install(valid_context)
      assert_file_contents_equal("baz", @target + "nested.txt")
    end

    def test_install_ignores_all_files_under_the_basis_dir
      @installer.install
      assert_file_does_not_exist(@target + "basis" + "ignored.txt")
    end
    
    def test_install_respects_the_lifecycle
      @lifecycle_installer.install
      assert_file_does_not_exist(@target + "nocopy.txt")
      assert_file_exists(@target + "copy.txt")
    end

    def test_install_asks_the_lifecycle_about_preexisting_files
      @installer.install

      def (@installer.lifecycle).install?(file)
        raise RuntimeError if file.exist?
        true
      end
    
      assert_file_exists(@target + "monkeys.txt")
      
      assert_raise(RuntimeError) { @installer.install }
    end
  end
end
