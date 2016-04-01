module Marksila
  class Renderer

    def self.render(text, options={})
      begin
        node = Parser.parse(text, options)
        node.to_html(options)
      rescue Exception => e
        "PARSING ERROR : #{e.message}"
      end
    end
  end
end
