# coding: utf-8

require 'json'
require 'fileutils'

module Tamarillo

  # Internal: Stores the configuration for Tamarillo.
  class Config2

    DEFAULT_PATH = "#{ENV['HOME']}/.tamarillo/config.json"
    DEFAULT_DURATION = (25 * 60)
    DEFAULT_NOTIFIER = 'bell'
    
    attr_accessor :attributes

    # Public: Initialize a new config object.
    def initialize(path = DEFAULT_PATH)
      @path = path

      create_default unless File.exist?(@path)
      load_attributes
    end
    
    private
    
    # Internal: Reads a config file and loads the attributes.
    def load_attributes
      data = File.read(@path)
      @attributes = JSON.parse(data)
    end

    # Internal: Generates a default config file.
    def create_default
      attributes = {
        'duration' => DEFAULT_DURATION,
        'notifier' => DEFAULT_NOTIFIER}

      dir_path = File.dirname(@path)
      FileUtils.mkdir_p(dir_path)

      File.open(@path, 'w') do |f|
        f << JSON.generate(attributes)
      end
    end

  end
end
