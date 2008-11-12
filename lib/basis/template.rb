require "uri"

module Basis
  class Template
    class << self
      def git(source)
        Basis::Templates::Git.new(source)
      end
      
      def local(source)
        Basis::Templates::Local.new(source)
      end
    end
    
    attr_reader :source

    def initialize(source)
      @source = source
    end
  end
end

require "basis/templates/local"
require "basis/templates/git"

