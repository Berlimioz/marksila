module Marksila
  class NewLineNode < Node

    def initialize(token)
      raise "A NewLineNode can only be created from a new_line token" unless (token.nil? || token.token_type == :new_line)
      super(token)
    end

    def to_html(options={})
      "<br />"
    end
  end

end
