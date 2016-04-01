class MyObjectsController < ApplicationController

  def index
    @object = MyObject.new
    options = {
      "variables" => {
        "VARIABLE1" => {
          object: @object,
          method: "display_variable_1"
        }
      }
    }
    @text = <<TEXT
{{h1}}This is a title h1{{end-h1}}
{{div}}
This is a div and this : [{{VARIABLE1}}] is the VARIABLE1
{{end}}
TEXT
    @marksila = Marksila::Renderer.render(@text, options).html_safe
  end

end
