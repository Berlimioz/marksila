module Marksila
  module Emails
    class << self
      attr_accessor :config
    end

    def self.config
      if @config.nil?
        @config =
          Marksila.config['email'] ||
            {
              'atoms' =>
                {
                  "{{" => 'open_tag',
                  "}}" => 'close_tag'
                },
              'html' =>
                {
                  'authorized_tags' => %w(div p h1 h2 h3 h4 h5 h6 )
                }
            }
      end
      @config
    end
  end
end
