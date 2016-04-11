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
require 'marksila/version'

module Marksila
  class << self
    attr_accessor :config
  end

  def self.config
    custom_file_path = "#{Dir.pwd}/config/marksila.yml"

    if @config.nil?
      @config ||= if File.exists?(custom_file_path)
                    YAML.load_file(custom_file_path)
                  else
                    YAML.load_file("#{File.expand_path(File.dirname(__FILE__))}/marksila/default_config.yml")
                  end

      if @config["atoms"].present?
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
end
