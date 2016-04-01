module Marksila
  module TestingActions::Node::Display

    def to_s
      to_return = self.display_info
      if self.children.present?
        to_return << '['
        to_return << self.children.collect{ |child| child.to_s }.join(',')
        to_return << ']'
      end
      to_return
    end

    def display_tree(level=0)
      to_return = "<tr>"
      level.times do
        to_return << "<td></td>"
      end
      to_return << "<td>#{self.class} : #{self.value}#{"##{self.css_id}" if self.css_id.present?}#{".#{self.css_classes.join('.')}" if self.css_classes.present?}</td>"
      to_return << "</tr>"
      if self.children.present?
        self.children.each do |child|
          to_return << child.display_tree(level+1)
        end
      end
      to_return
    end

    def display_info
      info = if self.is_a?(TextNode)
               "TEXT-#{value}"
             elsif self.is_a?(TagNode)
               info = "TAG-#{value}"
               if self.css_classes.present? || self.css_id.present?
                 extra = if self.css_classes.present? && self.css_id.present?
                           "##{self.css_id}.#{self.css_classes.join('.')}"
                         elsif self.css_classes.present?
                           ".#{self.css_classes.join('.')}"
                         else
                           "##{self.css_id}"
                         end
                 if self.html_data.present?
                   extra << " #{self.html_data.join(' ')}"
                 end
                 "#{info}(#{extra})"
               else
                 raise "Undefined display_info for Node type : #{self.class.name}"
               end
             end
      info
    end

  end
end

