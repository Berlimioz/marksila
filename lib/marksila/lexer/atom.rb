module Marksila

  class Lexer::Atom
    # include ::Marksila::TestingActions::Atom::Display

    attr_accessor :value, :atom_type

    def initialize(value, atom_type=:simple_text)
      @value = value
      #raise 'bloup' if @value == 'PLATFORM_TOTAL_CONFIRMED_BACKERS_AMOUNT'
      @atom_type = if @value.nil?
                     :simple_text
                   else
                     atom_force_type[@value] || atom_type
                   end
    end

    def atom_force_type
      @atom_types ||= (Marksila.config["atoms"] || {})
      @atom_types
    end

  end

end