require "uri"

module Basis
  module Templates
    class Local < Basis::Template
      def initialize(source)
        raise Basis::DirectoryNotFound.new(source) unless File.directory?(source)
        super
      end
    end
  end
end

