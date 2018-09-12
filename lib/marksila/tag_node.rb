module Marksila
  class TagNode < Node
    attr_accessor :opened, :html_data, :original_tag
    include CustomRules
    def initialize(token)
      raise "A TagNode can only be created from a text token" unless token.nil? || token.token_type == :tag
      raise "A TagNode can only be initialized from an opening tag token" unless token.nil? || token.opening_tag?
      raise "Invalid tag : #{token.try(:value)}" if token.try(:value) == "script"

      super(token)
      @opened = true
      @original_tag = token.value if token.present?
      self.init_with_rules(token)
    end

    def html_data_to_html
      self.html_data.collect do |html_data|
        if html_data =~ /^style='([\w\-]+:[\w\d%]+;)+'$/
          html_data
        elsif html_data =~ /^([\w]+)=("|')?([^'"\s]+)("|')?$/
          property = $1
          value = $3
          raise "Forbidden property : #{property}" if property == "rel"

          if property == "href" || property == "src"
            if value =~ /\A#{url_matching_pattern}\z/
              if value =~ /\A(.+)\.(js|css)(\?.+)?/
                raise "Invalid : javascript and css files are not allowed"
              end
            else
              raise "Invalid url : #{value}" unless value =~ /\A#{url_matching_pattern}\z/
            end
          end
          "#{property}='#{value}'"
        else
          raise "Invalid html data format : #{html_data}"
        end
      end.join(' ')
    end

    def url_matching_pattern
      "#{url_source_matching_pattern}(#{url_params_matching_pattern})?|#{tag_id_ref_matching_pattern}"
    end

    def url_source_matching_pattern
      '(https?:\/\/([\w\.\-_\d]+\.)+(\w+))?((\/?[\w\d_\-]+)+(\.(\w+))?)?'
    end

    def url_params_matching_pattern
      '\?([\w\d_\-\&\?\/=]+)'
    end

    def tag_id_ref_matching_pattern
      '\#[\w\d_\-]+'
    end

    def to_html(options={})
      to_return = ""
      if self.value.present? && self.value != 'ROOT'
        to_return << "<#{self.value}"
        to_return << " id='#{self.css_id}'" if self.css_id.present?
        to_return << " class='#{self.css_classes.join(' ')}'" if self.css_classes.present?
        to_return << " #{self.html_data_to_html}" if self.html_data.present?

        to_return << '>'

        if self.children.present?
          self.children.each do |child|
            to_return << child.to_html(options)
          end
        end
        to_return << "</#{self.value}>"
      else
        if self.children.present?
          self.children.each do |child|
            to_return << child.to_html(options)
          end
        end
      end
      to_return
    end

    def close_with(token)
      valid_closing_token = (token.value == self.get_closing_tag)
      raise "Invalid closing token #{token.value} for tag #{self.original_tag}." unless valid_closing_token
      self.opened = false
    end
  end
end
