require 'marksila/renderer'
require 'marksila/parser'
require 'marksila/lexer'
require 'marksila/lexer/atom'
require 'marksila/lexer/token'
require 'marksila/lexer/context'
# require 'marksila/testing_actions/atom/display'
# require 'marksila/testing_actions/token/display'
# require 'marksila/testing_actions/node/display'
require 'marksila/custom_rules'
require 'marksila/node'
require 'marksila/tag_node'
require 'marksila/text_node'
require 'marksila/variable_node'
require 'marksila/new_line_node'

require 'marksila/emails'
require 'marksila/emails/html_parser'
require 'marksila/emails/lexer'
require 'marksila/emails/lexer/atom'
require 'marksila/emails/lexer/context'
require 'marksila/emails/lexer/token'
require 'marksila/emails/html_parser/node'
require 'marksila/emails/html_parser/new_line_node'
require 'marksila/emails/html_parser/tag_node'
require 'marksila/emails/html_parser/text_node'
require 'marksila/emails/html_parser/variable_node'

require 'marksila/version'

module Marksila
  class << self
    attr_accessor :config
    attr_accessor :custom_node_tags

    def custom_node_tags
      @custom_node_tags ||= {}
    end
  end

  def self.config
    custom_file_path = "#{Dir.pwd}/config/marksila.yml"

    if @config.nil?
      @config ||= if File.exists?(custom_file_path)
                    YAML.load_file(custom_file_path)
                  else
                    YAML.load_file("#{File.expand_path(File.dirname(__FILE__))}/marksila/default_config.yml")
                  end

      if !@config["atoms"].nil? && !@config["atoms"].empty?
        @config["atoms"].keys.each do |k|
          if k =~ /\\n/
            @config["atoms"][k.gsub("\\n", "\n")] = @config["atoms"][k]
            @config["atoms"].delete(k)
          end
        end
      end
    end
    @config
  end

  def self.authorized_tags
    config['authorized_tags'] #+ (custom_node_tags.keys || [])
  end
end
