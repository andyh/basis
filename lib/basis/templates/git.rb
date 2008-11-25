module Basis
  module Templates
    class Git < Basis::Template
      handles :git
    end
  end
end

Basis::Template.add_handler Basis::Templates::Git
