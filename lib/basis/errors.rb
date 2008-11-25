module Basis
  class DirectoryNotFound < StandardError
    def initialize(directory)
      super("#{directory} doesn't exist")
    end
  end
  
  class TemplateHandlerNotFound < StandardError
    def initialize(type)
      # valid list shouldn't depend on require order, so sort
      valid = Basis::Template.handlers.keys.sort_by { |k| k.to_s }.join(", ")
      super("no template handler for '#{type}' (valid: #{valid})")
    end
  end
  
  class TemplateAlreadyExists < StandardError
    def initialize(moniker)
      super("template already exists: #{moniker}")
    end
  end
end
