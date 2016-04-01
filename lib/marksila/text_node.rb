module Marksila
  class TextNode < Node

    def initialize(token)
      raise "A TextNode can only be created from a text token" unless (token.nil? || token.token_type == :text)
      super(token)
    end

    def to_html(options={})
      if Marksila.config["simple_text_renderer"].present?
        Marksila.config["simple_text_renderer"].to_html(self.value, options.merge({parent: self.parent}))
      else
        self.value
      end
    end
  end

end
