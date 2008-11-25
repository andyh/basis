module Basis
  module Templates
    class Git < Basis::Template
    end
  end
end

Basis::Template.handlers[:git] = Basis::Templates::Git
