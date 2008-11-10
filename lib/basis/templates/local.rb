require "uri"

module Basis
  module Templates
    class Local < Basis::Template
      def initialize(path)
        super
        @url.scheme = "file"
      end
    end
  end
end
