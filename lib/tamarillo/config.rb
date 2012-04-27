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
      @duration_in_minutes = options.fetch(:duration_in_minutes) { DEFAULT_DURATION_IN_MINUTES }
    end

    # Public: Returns the duration of each tomato in seconds.
    def duration_in_seconds
      @duration_in_minutes * 60
    end
  end
end
