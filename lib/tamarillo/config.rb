require 'yaml'

module Tamarillo
  # Internal: This configures the Tamarillo CLI, which uses values from
  # this config when generating and interacting with Tomatoes. Currently
  # it just holds the duration of each tomato, but it will later
  # configure things like daemon process location and storage interface.
  class Config
    DEFAULT_DURATION_IN_MINUTES = 25

    # Public: Gets/Sets the duration of each Tomato in minutes.
    attr_accessor :duration_in_minutes

    # Public: Initializes a new config.
    #
    # options - The hash used to configure Tamarillo.
    #           :duration_in_minutes - The duration in minutes.
    def initialize(options = {})
      self.duration_in_minutes = options[:duration_in_minutes]
    end

    # Public: Returns the duration of each tomato in minutes.
    def duration_in_minutes
      @duration_in_minutes
    end
    alias :duration :duration_in_minutes

    # Public: Sets the duration of each tomato in minutes.
    #
    # Uses the default value if the value is invalid.
    def duration_in_minutes=(value)
      value = value.to_i
      @duration_in_minutes = (value > 0) ? value : DEFAULT_DURATION_IN_MINUTES
    end
    alias :duration= :duration_in_minutes=

    # Public: Returns the duration of each tomato in seconds.
    def duration_in_seconds
      @duration_in_minutes.to_i * 60
    end

    # Public: Initializes a config from a YAML file.
    #
    # This tries to read config data from YAML. If the YAML is missing
    # values or is invalid, defaults are used. If the file doesn't
    # exist, then a default configuration is created.
    #
    # path - String or Pathname to the YAML file.
    #
    # Returns: A config instance.
    def self.load(path)
      options = {}

      if File.exist?(path)
        yaml = YAML.load( File.read(path.to_s) ) || {}
        options[:duration_in_minutes] = yaml['duration']
      end

      new(options)
    end

    # Public: Write a config out to a file.
    #
    # path - a String or Pathname to the destination file.
    def write(path)
      File.open(path, 'w') { |f| f << to_yaml }
    end

    # Public: Returns config in YAML format.
    def to_yaml
      options = { 'duration' => duration_in_minutes }
      YAML.dump(options)
    end

  end
end
