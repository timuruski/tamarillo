module Tamarillo
  class Monitor
    # The time between checks.
    SLEEP_TIME = 0.3
    attr_reader :pid

    # Public: Initializes a new monitor.
    def initialize(tomato, notifier)
      @tomato = tomato
      @notifier = notifier
    end

    # Public: Starts watching a tomato for completion.
    def start
      @pid = fork do
        until @tomato.completed?
          sleep SLEEP_TIME
        end

        @notifier.call
      end

      Process.detach(@pid)
    end

  end
end
