# Marksila

Marksila stands for Markdownify Simple Language. It has been developped for [Markdownify editor](https://github.com/tibastral/markdownify) in the [Mipise](https://mipise.com) project in order to bring more customization possibilities to users.

## What is it ?

Marksila is a simple language based on tags generator for html rendering purpose.

## Usage

With Marksila, you can easily create your own simple language to be rendered in html, defining tags rules in a marksila.yml file to be placed in your config/ folder.

By default, a Marksila tag "{{tagName}}" starts a block, which should be closed by "{{end-tagName}}". If the tag corresponds to a predefined variable, then it does not need to be closed.

```
{{h1}} Some title {{end-h1}}
{{div#myDiv1}}

{{div#myDiv2}}
	{{h2}} {{MYVARIABLE}} {{end-h2}}
{{end}}

{{end}}
```

Will be rendered as :

```html
<h1>Some title</h1>
<div id='myDiv1'>
	<div id='myDiv2'>
		<h1>RESULT_OF_MYVARIABLE</h1>
	</div>
</div>
```

You can define in configuration file marksila.yml some other shortcuts :

```yaml
atoms:
  "{{": open_tag
  "}}": close_tag
custom_tags:
  fdiv:
    html_tag: div
    classes:
      - fixed-action-btn
    style_data_regexp:
      - (bottom|right)=([0-9\-]+%)
    closing_tag: endf
```

With this configuration, this marksila code :

```
{{fdiv right=2%}}
Some text
{{endf}}
```

will be rendered in html as :

```html
<div class='fixed-action-btn' style='right: 2px;'>
Some text
</div>
```

## Using marksila along with another markup language

In a Marksila language, you have two different kinds of data : tags and simple text. If you need to, you can plug another renderer for the simple text part.

Let's say that you wish to use your Marksila language along with Markdown. Then all you have to do is passing Marksila.config["simple_text_renderer"] an object responding to a to_html(val,opts) method that returns the html rendering of markdown code.

 ```ruby
 class MyMarkdownRenderer
  def to_html(text,options={})
    render_to_markdown(text,options)
  end
 end
 Marksila.config["simple_text_renderer"] = MyMarkdownRenderer.new
 ```
With this kind of code, part of text out of marksila tags will be rendered as markdown to html, so that something like :

```
{{div}}
Some text here
{{end-div}}
* first item
* second item
### A small title
```

will be rendered in html as :

```html
<div>
	<p>Some text here</p>
</div>
<ul>
	<li>first item</li>
	<li>second item</li>
</ul>
<h3>A small title</h3>
```

This project rocks and uses MIT-LICENSE.
