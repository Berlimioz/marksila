module Marksila
  module Emails
    module HtmlParser
      attr_accessor :config
      attr_accessor :custom_node_tags

      def self.parse(text, options={})
        tokens = ::Marksila::Emails::Lexer.new(text).lex
        root_node = ::Marksila::Emails::HtmlParser::TagNode.new(nil)
        root_node.value = 'ROOT'
        current_node = root_node
        unless tokens.empty?
          tokens.select{ |t| !t.nil? }.each do |token|
            current_node = current_node.create_next_node(token, options)
          end
        end
        root_node
      end

      def self.authorized_tags
        self.config['authorized_tags']
      end

      def self.custom_node_tags
        @custom_node_tags ||= (self.config['custom_node_tags'] || {})
      end

      def self.config
        @config ||= (Marksila::Emails.config['html'] || {})
      end
    end
  end
end
