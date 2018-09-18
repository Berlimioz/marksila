RSpec.describe Marksila::Emails::HtmlParser do
  before do
    stubs(:user).returns(
      Struct.new('User', :name).new('Alain Loulou')
    )
    Marksila::Emails::HtmlParser.stubs(:config).returns(
      {
        'authorized_tags' => %w(div p h1 h2 h3 h4 h5 h6)
      }
    )
  end

  describe '#parse' do
    let(:parser) { Marksila::Emails::HtmlParser }
    let(:text) {
      <<_TEXT_TO_PARSE
{{div}}
{{p}}Bonjour {{USERNAME}},{{end-p}}

{{div}}Ici vient une div{{end-div}}

{{h1}}Ceci est un titre{{end-h1}}

{{p}}Merci bonne journée,{{end-p}}
{{p}}La plateforme{{end-p}}
{{end-div}}
_TEXT_TO_PARSE
    }
    let(:expected_html) {
      <<_HTML
<div>
<p>Bonjour Alain Loulou,</p>

<div>Ici vient une div</div>

<h1>Ceci est un titre</h1>

<p>Merci bonne journée,</p>
<p>La plateforme</p>
</div>
_HTML
    }

    it 'generates expected html', wip: true do
      opts = { 'variables' => { 'USERNAME' => { method: 'name', object: user } } }
      node = parser.parse(text, opts)
      expect(node.to_html(opts)).to eq(expected_html)
    end
  end
end
