require "fileutils"

module Basis
  module Templates
    class Local < Basis::Template
      handles :local

      def initialize repository, type, source, name = nil
        source = File.expand_path(source)
        raise Basis::DirectoryNotFound.new(source) unless File.directory? source
        super(repository, type, source, name)
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

Basis::Template.add_handler Basis::Templates::Local
