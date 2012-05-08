module Tamarillo
  class Monitor
    # The time between checks.
    SLEEP_TIME = 0.3

    # Public: Initializes a new monitor.
    def initialize(tomato, &callback)
      @tomato = tomato
      @callback = callback
    end

    # Public: Starts watching a tomato for completion.
    def start
      until @tomato.completed?
        sleep SLEEP_TIME
      end

      @callback.call
    end
  end
end
