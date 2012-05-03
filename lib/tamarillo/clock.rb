require 'date'

# Internal: Keeps track of time elapsed.
#
# The Clock model reprensents the amount of time elapsed since
# the time a Pomodoro/Tomato began, typically measured in 
# 15-25 minute blocks.
#
module Tamarillo
  class Clock
    attr_reader :start_time, :start_date

    # Public: Initialize a new clock.
    #
    # start_time - A Time instance when the clock was started.
    def initialize(start_time)
      @start_time = start_time
      @start_date = start_time.to_date
    end

    # Public: Returns a clock starting at the current time.
    def self.now
      new(Time.now)
    end

    # Public: Calculate time elapsed.
    #
    # Returns the number of seconds since the clock started.
    def elapsed
      Time.now.to_i - @start_time.to_i
    end
  end
end
