module Marksila
  class Lexer

    def initialize(text)
      @text = text
    end

    def lex
      atoms = self.create_atoms
      @context = Context.new

      atoms.each do |atom|
        @context.handle_atom(atom)
      end

      @context.tokens
    end

    def create_atoms
      if Marksila.config["atoms"].present?
        p = Marksila.config["atoms"].keys.join("|")

        @str_atoms = @text.split(/(#{p})/)
        @str_atoms.collect do |str_atom|
          Atom.new(str_atom)
        end#.select{|s| !s.nil?}
      else
        raise "No configuration found..."
      end
    end
  end

end
