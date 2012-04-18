require 'date'

module Tamarillo
  class Clock
    attr_reader :start_time, :start_date
    def initialize(start_time)
      @start_time = start_time
      @start_date = start_time.to_date
    end

    def elapsed
      Time.now.to_i - @start_time.to_i
    end
  end
end
