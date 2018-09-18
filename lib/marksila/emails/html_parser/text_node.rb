module Marksila
  module Emails
    module HtmlParser
      class TextNode < ::Marksila::Emails::HtmlParser::Node

        def initialize(token)
          raise "A TextNode can only be created from a text token" unless (token.nil? || token.token_type == :text)
          super(token)
        end

        def to_html(options={})
          simple_text_config = Marksila::Emails.config['simple_text_renderer']
          unless simple_text_config.nil?
            simple_text_config.to_html(self.value, options.merge({parent: self.parent}))
          else
            self.value
          end
        end
      end
    end
  end
end
