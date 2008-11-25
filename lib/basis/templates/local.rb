require "fileutils"

module Basis
  module Templates
    class Local < Basis::Template
      def initialize repository, source, name = nil
        raise Basis::DirectoryNotFound.new(source) unless File.directory? source
        super
      end
      
      def create
        FileUtils.rmtree cache
        FileUtils.mkdir_p cache
        FileUtils.cp_r Dir.glob(File.join(source, "*")), cache
      end

      alias_method :update, :create
    end
  end
end

Basis::Template.handlers[:local] = Basis::Templates::Local
