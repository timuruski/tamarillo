require 'date'

module Tamarillo
  class Pomodoro
    module States
      ACTIVE = :active.freeze
      COMPLETED = :completed.freeze
      INTERRUPTED = :interrupted.freeze
    end

    attr_reader :duration, :started_at, :date

    def initialize(duration, started_at = nil)
      @duration = duration
      @started_at = started_at || Time.now
      @date = @started_at.to_date
    end

    def remaining
      d = (@started_at.to_i + @duration) - Time.now.to_i
      d > 0 ? d : 0
    end

    def interrupt!
      @interrupted = true
    end

    def state
      if @interrupted
        States::INTERRUPTED
      elsif remaining == 0
        States::COMPLETED
      else
        States::ACTIVE
      end
    end

  end
end
