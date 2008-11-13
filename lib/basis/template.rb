require "digest/sha1"
require "uri"
require "yaml"

module Basis
  class Template
    attr_reader :cache, :source

    def initialize(repository, source)
      @repository = repository
      @source = source
      
      @cache = repository.path + "#{File.basename(source)}-#{Digest::SHA1.hexdigest(source)}"
    end
    
    def cached?
      @cache.exist?
    end
    
    def config
      config = @cache + "basis" + "config.yml"
      config.exist? ? YAML.load(config.read) : {}
    end
  end
end

require "basis/templates/local"
require "basis/templates/git"
