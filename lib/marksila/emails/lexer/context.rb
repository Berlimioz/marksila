module Marksila
  module Emails
    class Lexer::Context
      attr_accessor :atoms, :tokens, :current_token

      STATES = [:opening_brackets, :closing_brackets, :text_into_brackets, :simple_text]

      def initialize
        @atoms = []
        @tokens = []
        @current_token = nil
      end

      def handle_atom(atom)
        self.send(self.state_for(atom), atom)
      end

      # ======= METHODS TO HANDLE TOKEN ADDITION TO WORDS =======
      def add_atom_to_tokens(atom, token_type=atom&.atom_type)
        self.atoms << atom
        self.send("add_#{token_type}_to_tokens", atom)
      end

      def add_simple_text_to_tokens(atom)
        self.tokens << Marksila::Emails::Lexer::Token.new_from_simple_text(atom)
      end

      def add_new_line_to_tokens(atom)
        self.tokens << Marksila::Emails::Lexer::Token.new(:new_line, atom.value)
      end

      def add_open_tag_to_tokens(atom)
        self.current_token = Marksila::Emails::Lexer::Token.new(:tag)
      end

      def add_close_tag_to_tokens(atom)
        self.tokens << self.current_token
        self.current_token = nil
      end

      # def add_variable_name_to_tokens(atom)
      #   self.current_token = Lexer::Token.new(:variable_name, atom.value)
      # end


      # === Some modifs here

      def add_data_to_current_token(value, value_type)
        self.send("add_#{value_type}_to_current_token", value)
      end

      def add_tag_name_to_current_token(value)
        self.current_token.value = value
      end

      def add_html_data_to_current_token(value)
        self.current_token.html_data << value
      end

      # ========================================================

      def state_for(atom)
        return nil if atom.nil?

        last_atom = self.atoms.last
        last_atom_type = last_atom.atom_type unless last_atom.nil?
        if atom.atom_type == 'open_tag'
          :opening_brackets
        elsif atom.atom_type == "close_tag"
          :closing_brackets
        elsif atom.atom_type == "new_line"
          :new_line
        elsif !last_atom_type.nil? && last_atom_type == 'open_tag'
          :text_into_brackets
        else
          :simple_text
        end
      end

      # ======= METHODS TO CALL DEPENDING ON CONTEXT STATE FOR A CHARACTER ========

      def opening_brackets(atom)
        self.add_atom_to_tokens(atom)
        self.current_token = Marksila::Emails::Lexer::Token.new(:tag)
      end

      def closing_brackets(atom)
        self.add_atom_to_tokens(atom)
      end

      def new_line(atom)
        self.add_atom_to_tokens(atom)
      end

      def text_into_brackets(atom)
        last_atom_type = self.atoms.last&.atom_type
        if last_atom_type == :open_bracket
          if self.atoms.last&.atom_type == :open_bracket
            raise "Invalid atom : you cannot have opening brackets if previous ones have not been closed."
          end
        elsif last_atom_type == :simple_text
          raise "You should not have this kind of atom (#{atom&.atom_type}) here..."
        end

        buffer = ''
        current_atom_type = :tag_name
        atom.value.each_char do |c|
          if c == ' '
            self.add_data_to_current_token(buffer, current_atom_type)
            buffer = ''
            current_atom_type = :html_data
          else
            buffer << c
          end
        end
        self.add_data_to_current_token(buffer, current_atom_type) unless buffer.nil? || buffer.empty?
        self.atoms << atom
      end

      def simple_text(atom)
        last_atom = self.atoms.last
        if !last_atom.nil? && last_atom.atom_type == :open_bracket
          raise "You should not have a simple text token type after an opening brackets one"
        end
        add_atom_to_tokens(atom)
      end

    end
  end
end