require "pathname"
require "yaml"

module Basis
  class Repository
    attr_reader :path, :templates

    def initialize path = "~/.basis"
      @path = Pathname.new(File.expand_path(path)).freeze
      raise Basis::DirectoryNotFound.new(@path) unless @path.exist?

      @templates = load_templates
    end
    
    def add type, source, name = nil
      klass = handler_for(type)      
      source &&= source.strip
      
      unless source && !source.empty?
        raise ArgumentError.new("source is required")
      end

      if @templates.any? { |t| t.source == source }
        raise Basis::TemplateAlreadyExists.new(source)
      end

      instance = klass.new(self, type, source, name)
      instance.update!
      
      if @templates.any? { |t| t.name == instance.name }
        raise Basis::TemplateAlreadyExists.new(instance.name)
      end
      
      @templates << instance
      save_templates
    end
    
    def remove name
      @templates.reject! { |t| t.name == name }
      save_templates
    end
    
    private
    
    def handler_for(type)
      klass = Basis::Template.handlers[type.to_sym]      
      raise Basis::TemplateHandlerNotFound.new(type) unless klass
      klass
    end
    
    def templates_yml_path
      @path + "templates.yml"
    end
    
    def load_templates
      return [] unless templates_yml_path.exist?
      
      templates = []
      
      YAML.load(IO.read(templates_yml_path)).each do |name, data|
        klass = handler_for(data["type"])
        templates << klass.new(self, data["type"], data["source"], name)
      end
    
      templates.sort { |a, b| a.name <=> b.name }
    end
    
    def save_templates
      hashified = {}
      
      @templates.each do |t|
        hashified[t.name] = { "source" => t.source, "type" => t.type.to_s }
      end
    
      File.open(templates_yml_path, "w") do |f|
        f.write(YAML.dump(hashified))
      end
      
      @templates
    end
  end
end
