module Marksila
  module TestingActions::Atom::Display

    def display
      stringify = "[#{self.atom_type}:#{self.value}]"
      stringify
    end
  end

end

