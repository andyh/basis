require "helper"

module Basis
  class RepositoryTest < Test::Unit::TestCase
    def setup
      path = File.join(Dir.tmpdir, "repository")
      FileUtils.rm_rf(path)
      FileUtils.mkdir_p(path)
      
      @repo = Basis::Repository.new(path)
    end

    def test_initialized_explodes_on_bad_paths
      assert_raise Basis::DirectoryNotFound do
        Basis::Repository.new File.join(Dir.tmpdir, "nonexistent")
      end
    end
    
    def test_add_complains_about_unknown_template_handlers
      ex = assert_raise Basis::TemplateHandlerNotFound do
        @repo.add :monkey, "asource"
      end
      
      assert_equal "no template handler for 'monkey' (valid: git, local)", ex.message
    end
    
    def test_add_complains_about_duplicate_names
      @repo.add :local, FIXTURES_PATH + "/static", "foo"
      
      assert_raise Basis::TemplateAlreadyExists do
        @repo.add :local, FIXTURES_PATH + "/dynamic", "foo"
      end
    end
    
    def test_add_complains_about_duplicate_sources
      @repo.add :local, FIXTURES_PATH + "/static", "foo"
      
      assert_raise Basis::TemplateAlreadyExists do
        @repo.add :local, FIXTURES_PATH + "/static", "bar"
      end
    end
    
    def test_add_requires_a_source
      assert_raise(ArgumentError) { @repo.add :local, nil }
      assert_raise(ArgumentError) { @repo.add :local, "" }
      assert_raise(ArgumentError) { @repo.add :local, "   " }
    end
    
    def test_can_add_a_template
      @repo.add :local, FIXTURES_PATH + "/static", "local"
      
      template = @repo.templates.first
      assert_kind_of Templates::Local, template
      assert_equal "local", template.name
      assert_equal FIXTURES_PATH + "/static", template.source
    end
    
    def test_adding_a_template_with_a_name_in_its_config_comes_through
      @repo.add :local, FIXTURES_PATH + "/static"
      assert_equal "static!", @repo.templates.first.name
    end
    
    def test_adding_a_template_with_no_name_defaults_sanely
      @repo.add :local, FIXTURES_PATH + "/dynamic" # no basis/config.yml
      assert_equal "dynamic", @repo.templates.first.name
    end
    
    def test_can_remove_a_template
      @repo.add :local, FIXTURES_PATH + "/static"
      @repo.remove @repo.templates.first.name
      assert_equal [], @repo.templates
    end
    
    def test_persisting_templates
      @repo.add :local, FIXTURES_PATH + "/static"
      other = Repository.new(@repo.path)
      assert_equal @repo.templates, other.templates
    end
  end
end
