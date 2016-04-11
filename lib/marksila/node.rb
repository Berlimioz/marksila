
module Marksila
  class Node
    attr_accessor :value, :children, :parent, :css_id, :css_classes, :html_data
    #include TestingActions::Node::Display

    def initialize(token)
      if token.present?
        @value = token.value
        @css_id = token.css_id
        @css_classes = token.css_classes
        @html_data = token.html_data
      end
      @children = []
    end

    def create_next_node(token, options={})
      current_node = self
      if current_node.opened
        if token.token_type == :text
          new_node = TextNode.new(token)
          new_node.parent = current_node
          current_node.children << new_node
        elsif token.token_type == :new_line
          new_node = NewLineNode.new(token)
          new_node.parent = current_node
          current_node.children << new_node
        elsif options["variables"].present? && options["variables"].keys.include?(token.value)
          new_node = VariableNode.new(token)
          new_node.parent = current_node
          current_node.children << new_node
        else
          if token.opening_tag?
            new_node = TagNode.new(token)
            new_node.parent = current_node
            current_node.children << new_node
            current_node = new_node
          elsif token.closing_tag?
            current_node.close_with(token)
            current_node = current_node.parent
          else
            raise "You should never fall here : your token does not match anything : #{token.token_type} : #{token.value} (and options[variables] = #{options["variables"].inspect})"
          end
        end
      else
        raise "You can not add a token if the node is closed."
      end

      current_node
    end

  end
end
