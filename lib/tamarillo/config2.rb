# coding: utf-8

require 'json'
require 'fileutils'

module Tamarillo

  # Internal: Stores the configuration for Tamarillo.
  class Config2

    DEFAULT_PATH = "#{ENV['HOME']}/.tamarillo/config.json"
    DEFAULT_DURATION = 25 # minutes
    DEFAULT_NOTIFIER = 'bell'

    # Public: Initialize a new config object.
    def initialize(path)
      @path = path

      default_attributes unless valid_file?
      load_attributes
    end

    # Public: Returns the attributes hash.
    def attributes
      @attributes
    end

    # Public: Sets the attributes hash, while coercing
    # value types and injecting defaults.
    def attributes=(hash)
      hash = coerce_values(hash)
      hash = remove_invalid(hash)
      hash = inject_defaults(hash)
      @attributes = hash
    end

    # Public: Writes attributes to JSON file.
    def save
      write(@attributes)
    end

    private

    # Internal: Reads a config file and loads the attributes.
    def load_attributes
      data = File.read(@path)
      @attributes = JSON.parse(data)
    end

    # Internal: Generates a default config file.
    def default_attributes
      attributes = inject_defaults({})
      write(attributes)
    end

    # Internal: Coerces specific attributes to the correct type.
    def coerce_values(attributes)
      coercions = {
        'duration' => :to_i,
        'notifier' => :to_s }

      coercions.each do |key, method|
        if attributes.key?(key)
          value = attributes[key]
          value = value.send(method) rescue value
          attributes[key] = value
        end
      end

      attributes
    end

    # Internal: Removes invalid attributes.
    def remove_invalid(attributes)
      invalid_values = {
        'duration' => 0,
        'notifier' => '' }

      invalid_values.each do |key, invalid_value|
        if attributes.key?(key)
          value = attributes[key]
          attributes.delete(key) if value == invalid_value
        end
      end

      attributes
    end

    # Internal: Injects default values missing from attributes hash.
    def inject_defaults(attributes)
      defaults = {
        'duration' => DEFAULT_DURATION,
        'notifier' => DEFAULT_NOTIFIER }

      defaults.merge(attributes)
    end

    # Internal: Writes an attributes hash to the config path.
    def write(attributes)
      dir_path = File.dirname(@path)
      FileUtils.mkdir_p(dir_path)

      File.open(@path, 'w') do |f|
        f << JSON.generate(attributes)
      end
    end

    # Internal: Returns true if the config file exists.
    def valid_file?
      File.size?(@path)
    end

  end
end
