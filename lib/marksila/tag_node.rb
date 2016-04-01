module Marksila

  class TagNode < Node
    attr_accessor :opened, :html_data, :original_tag
    include CustomRules

    def initialize(token)
      raise "A TagNode can only be created from a text token" unless token.nil? || token.token_type == :tag
      raise "A TagNode can only be initialized from an opening tag token" unless token.nil? || token.opening_tag?
      super(token)
      @opened = true
      @original_tag = token.value if token.present?
      self.init_with_rules(token)
    end

    def html_data_to_html
      self.html_data.collect do |html_data|
        if html_data =~ /^([\w]+)=([^=']+)$/
          "#{$1}='#{$2}'"
        elsif html_data =~ /^style='([\w\-]+:[\w\d%]+;)+'$/
          html_data
        else
          raise "Invalid html data format : #{html_data}"
        end
      end.join(' ')
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
