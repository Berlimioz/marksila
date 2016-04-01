module Marksila
  module TestingActions::Token::Display

    def display
      stringify = "#{self.token_type}:#{self.value}"
      if self.css_classes.present? || self.css_id.present?
        suf = if self.css_classes.present? && self.css_id.present?
                "##{self.css_id}.#{self.css_classes.join('.')}"
              elsif self.css_classes.present?
                ".#{self.css_classes.join('.')}"
              else
                "##{self.css_id}"
              end
        stringify = "#{stringify}(#{suf})"
      end
      stringify
    end

    def display_extra_info
      info_a = []
      if self.css_classes.present?
        info_a << "css_classes : [#{self.css_classes.join(",")}]"
      end
      if self.css_id.present?
        info_a << "css_id : #{self.css_id}"
      end
      if self.html_datas.present?
        info_a << "html_data : [#{self.html_data.join(" ")}]"
      end
      info_a.join(" --- ")
    end
  end

end

