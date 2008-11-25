require "pathname"
require "yaml"

module Basis
  class Config < Hash
    def initialize(path)
      @path = Pathname.new(File.expand_path(path))
      replace(YAML.load(@path.read)) if @path.exist?
    end
    
    def save
      File.open(@path, "w") do |f|
        f.write(YAML.dump(self))
      end
    end
  end
end
