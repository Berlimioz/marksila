module Marksila

  class Parser

    # The input text is the pre-processed html from markdown parser.
    def self.parse(text, options={})
      tokens = Lexer.new(text).lex

      root_node = TagNode.new(nil)
      root_node.value = 'ROOT'
      current_node = root_node
      unless tokens.empty?
        tokens.select(&:present?).each do |token|
          current_node = current_node.create_next_node(token, options)
        end
      end
      root_node
    end

  end

end
