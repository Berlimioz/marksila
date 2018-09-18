module Marksila
  module Emails
    module HtmlParser
      class Node
        attr_accessor :value, :children, :parent, :html_data

        def initialize(token)
          unless token.nil?
            @value = token.value
            @html_data = token.html_data
          end
          @children = []
        end

        def create_next_node(token, options={})
          current_node = self
          if current_node.opened
            if token.token_type == :text
              new_node = Marksila::Emails::HtmlParser::TextNode.new(token)
              new_node.parent = current_node
              current_node.children << new_node
            elsif token.token_type == :new_line
              new_node = Marksila::Emails::HtmlParser::NewLineNode.new(token)
              new_node.parent = current_node
              current_node.children << new_node
            elsif !options["variables"].nil? && !options["variables"].empty? && options["variables"].keys.include?(token.value)
              new_node = Marksila::Emails::HtmlParser::VariableNode.new(token)
              new_node.parent = current_node
              current_node.children << new_node
            else
              if token.opening_tag?
                new_node =
                  if Marksila::Emails::HtmlParser.custom_node_tags.keys.include?(token.value)
                    Marksila::Emails::HtmlParser.custom_node_tags[token.value].constantize.new(token)
                  else
                    Marksila::Emails::HtmlParser::TagNode.new(token)
                  end

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

        def get_closing_tag
          "end-#{self.original_tag}"
        end
      end
    end
  end
end
