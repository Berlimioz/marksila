module Marksila

  class VariableNode < Node
    def initialize(token)
      raise "A VariableNode can only be created from a variable name token" unless token.nil? || token.token_type == :variable_name || token.token_type == :tag
      super(token)
    end

    def to_html(options={})
      object = options["variables"][self.value][:object] if options["variables"].present? && options["variables"][self.value].present?
      to_return = if object.present?
                    begin
                      to_return = object.send(options["variables"][self.value][:method])
                    rescue Exception => e
                      to_return = "{{UNDEFINED : #{self.value}}}"
                    end
                    to_return
                  else
                    # WE DO NOT PARSE THIS.
                    "{{#{self.value}}}"
                  end
      to_return
    end

  end
end
