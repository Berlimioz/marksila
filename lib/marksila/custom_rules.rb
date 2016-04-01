module Marksila
  module CustomRules
    def init_with_rules(token)
      if token.present? && Marksila.config["custom_tags"].present?
        if Marksila.config["custom_tags"].keys.include?(token.value)
          classes = Marksila.config["custom_tags"][token.value]["classes"]
          html_tag = Marksila.config["custom_tags"][token.value]["html_tag"]
          style = Marksila.config["custom_tags"][token.value]["style"]
          style_data_regexp = Marksila.config["custom_tags"][token.value]["style_data_regexp"]
          self.css_classes << classes if classes.present?
          self.value = html_tag if html_tag.present?

          if style.present? || style_data_regexp.present?
            html_data_a = []
            if style.present?
              html_data_a << style
            end
            if style_data_regexp.present?
              data_to_remove = []
              self.html_data.each do |d|
                style_data_regexp.each do |p|
                  if d =~ /#{p}/
                    data_to_remove << d
                    html_data_a << "#{$1}:#{$2};"
                  end
                end
              end

              if html_data_a.present?
                self.html_data -= data_to_remove
                self.html_data << "style='#{html_data_a.join('')}'"
              end
            end
            html_data_s = "'"
            self.html_data << html_data_s
          end
        end
      end
    end

    def get_closing_tag
      default_closing_tag = "end-#{self.original_tag}"
      if self.original_tag.present? && Marksila.config["custom_tags"].present? && Marksila.config["custom_tags"][self.original_tag].present?
        Marksila.config["custom_tags"][self.original_tag]["closing_tag"] || default_closing_tag
      else
        default_closing_tag
      end
    end

  end

end
