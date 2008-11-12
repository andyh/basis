require "uri"

module Basis
  class Template
    attr_reader :source

    def initialize(repository, source)
      @repository = repository
      @source = source
    end
  end
end

require "basis/templates/local"
require "basis/templates/git"
