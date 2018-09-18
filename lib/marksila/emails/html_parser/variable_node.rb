module Marksila
  module Emails
    module HtmlParser
      class VariableNode < ::Marksila::Emails::HtmlParser::Node
        def initialize(token)
          raise "A VariableNode can only be created from a variable name token" unless token.nil? || token.token_type == :variable_name || token.token_type == :tag
          super(token)
        end

        def to_html(options={})
          var_opts = options["variables"]
          val_config = var_opts[self.value] if !var_opts.nil? && var_opts.has_key?(self.value)
          object = val_config[:object] if !val_config.nil? && val_config.has_key?(:object)

          to_return = unless object.nil?
            begin
              if !html_data.nil? && html_data.any?
                data_opts = {}
                html_data.each do |data|
                  vals = data.split "="
                  data_opts[vals[0]] = vals[1]
                end
                to_return = object.send(options["variables"][self.value][:method], data_opts)
              else
                puts "*** METHOD *** #{options["variables"][self.value][:method]}"
                to_return = object.send(options["variables"][self.value][:method])
              end

            rescue Exception => e
              to_return = "{{UNDEFINED : #{self.value}}} [#{e.message}, #{e.backtrace}, html_data='#{html_data}']"
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
  end
end
