require "uri"

module Basis
  class Template
    class << self
      protected :new
      
      def git(repository)
        Basis::Templates::Git.new(repository)
      end
      
      def local(path)
        Basis::Templates::Local.new(path)
      end
    end
    
    attr_reader :url

    protected
    
    def initialize(url)
      @url = URI === url ? url : URI.parse(url)
    end
  end
end

require "basis/templates/local"
require "basis/templates/git"
