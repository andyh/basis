require "pathname"

module Basis
  class Repository
    attr_reader :path, :templates

    def initialize path = "~/basis"
      @path = Pathname.new(path).freeze
      raise Basis::DirectoryNotFound.new(@path) unless @path.directory?

      @templates = []
    end
    
    def add type, source, name = nil
      klass = Basis::Template.handlers[type]      
      raise Basis::TemplateHandlerNotFound.new(type) unless klass
      
      source &&= source.strip
      
      unless source && !source.empty?
        raise ArgumentError.new("source is required")
      end

      if @templates.any? { |t| t.source == source }
        raise Basis::TemplateAlreadyExists.new(source)
      end

      instance = klass.new(self, source, name)
      instance.update!
      
      if @templates.any? { |t| t.name == instance.name }
        raise Basis::TemplateAlreadyExists.new(instance.name)
      end
      
      @templates << instance
    end
    
    def remove name
      @templates.reject! { |t| t.name == name }
    end
  end
end
