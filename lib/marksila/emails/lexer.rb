module Marksila
  module Emails
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
        atom_config = Marksila::Emails.config["atoms"]
        if !atom_config.nil? && !atom_config.empty?
          p = atom_config.keys.join("|")

          @str_atoms = @text.split(/(#{p})/)
          @str_atoms.collect do |str_atom|
            Atom.new(str_atom)
          end
        else
          raise "No configuration found..."
        end
      end
    end
  end
end
