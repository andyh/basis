require "digest/sha1"
require "uri"
require "yaml"

module Basis
  class Template
    
    # Used on subclasses to document which template types the subclass knows
    # how to handle.

    def self.handles(*types)
      @handles ||= types
    end

    # Add a new template type handler to Basis' list. Adding a handler class
    # that handles an already-registered type will replace its handler.

    def self.add_handler(klass)
      klass.handles.each { |type| handlers[type] = klass }
    end

    # A hash of template type symbols to template handler classes. Basis uses
    # this to decide how to create and update local caches. Some built-ins:
    #
    # [:local]  Basis::Templates::Local
    # [:git]    Basis::Templates::Git
    
    def self.handlers
      @map ||= {}
    end
    
    attr_reader :cache, :source, :type
    
    def initialize repository, type, source, name = nil
      @repository = repository
      @type = type
      @name = name
      @source = source
      
      # FIXME: sanitize
      @cache = repository.path + "#{File.basename(@source, ".git")}-#{Digest::SHA1.hexdigest(@source)}"
    end
    
    def name
      # little bit of a special case for git, but it's harmless
      @name || config["name"] || File.basename(@source, ".git")
    end
    
    def cached?
      @cache.exist?
    end
    
    def config
      config = @cache + "basis" + "config.yml"
      config.exist? ? YAML.load(config.read) : {}
    end
    
    def update!
      cached? ? update : create
    end

    def eql? other
      self == other
    end

    def == other
      other.equal?(self) ||
        (other.instance_of?(self.class) &&
          other.name == name && other.source == source)
    end
    
    protected
    
    def create
      raise NotImplementedError, "implement in subclasses"
    end
    
    def update
      raise NotImplementedError, "implement in subclasses"
    end    
  end
end

require "basis/templates/local"
require "basis/templates/git"
