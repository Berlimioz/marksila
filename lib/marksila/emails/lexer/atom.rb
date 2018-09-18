module Marksila
  module Emails
    class Lexer::Atom
      # include ::Marksila::TestingActions::Atom::Display
      attr_accessor :value, :atom_type

      def initialize(value, atom_type=:simple_text)
        @value = value
        @atom_type =
          if @value.nil?
            :simple_text
          else
            atom_force_type[@value] || atom_type
          end
      end

      def atom_force_type
        @atom_types ||= (Marksila::Emails.config['atoms'] || {})
        @atom_types
      end
    end
  end
end
