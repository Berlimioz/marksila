module Marksila
  module Emails
    class HtmlRenderer
      def self.render(text, options={})
        begin
          node = Marksila::Emails::HtmlParser.parse(text, options)
          node.to_html(options)
        rescue Exception => e
          "PARSING ERROR : #{e.message}"
        end
      end
    end
  end
end
