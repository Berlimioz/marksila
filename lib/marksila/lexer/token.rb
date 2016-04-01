module Marksila

  class Lexer::Token
    #include TestingActions::Token::Display
    attr_accessor :token_type, :value, :css_classes, :css_id, :html_data

    WORD_TYPES = [:tag, :text, :variable_name]

    # TODO : make sure html_data is right formated
    def initialize(token_type, value=nil, css_classes=[], css_id=nil, html_data: [])
      @token_type = token_type.to_sym if WORD_TYPES.include?(token_type.to_sym)
      @value = value
      @css_classes = css_classes
      @css_id = css_id
      @html_data = html_data
    end

    def self.new_from_simple_text(atom)
      if atom.atom_type == :simple_text
        token = new(:text, atom.value)
      else
        raise "Simple text atom only here"
      end
      token
    end

    def opening_tag?
      self.token_type == :tag && !(self.value =~ /^end.*/)
    end

    def closing_tag?
      self.token_type == :tag && self.value =~ /^end.*/
    end

  end
end
