require "digest/sha1"
require "uri"
require "yaml"

module Basis
  class Template
    attr_reader :cache, :source
    
    # A hash of template type symbols to template handler classes. Basis uses
    # this to decide how to create and update local caches. Some built-ins:
    #
    # [:local]  Basis::Templates::Local
    # [:git]    Basis::Templates::Git
    
    def self.handlers
      @map ||= {}
    end
    
    def initialize repository, source, name = nil
      @repository = repository
      @name = name
      @source = source
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
