require "pathname"

module Basis
  class Repository
    attr_reader :path, :templates

    def initialize(path="~/basis")
      @path = Pathname.new(path).freeze
      raise Basis::DirectoryNotFound.new(@path) unless @path.directory?

      @templates = read_templates
    end

    private

    def read_templates
      template_file_path.exist? ? YAML.load(template_file_path.read) : {}
    end

    def write_templates
      File.open(file, "w") { |f| f.write(YAML.dump(hashified)) }
    end

    def template_file_path
      @path + "templates.yml"
    end

    # Lifted from ActiveSupport:
    # http://github.com/rails/rails/tree/master/activesupport/lib/active_support/inflector.rb

    def constantize(camel_cased_word)
      names = camel_cased_word.split('::')
      names.shift if names.empty? || names.first.empty?

      constant = Object

      names.each do |name|
        constant = constant.const_defined?(name) ?
          constant.const_get(name) :
          constant.const_missing(name)
      end

      constant
    end
  end
end
