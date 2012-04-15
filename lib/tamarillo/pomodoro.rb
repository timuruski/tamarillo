module Tamarillo
  class Pomodoro
    def initialize(duration, started_at = nil)
      @duration = duration
      @started_at = (started_at || Time.now).to_i
    end

    def duration
      @duration
    end

    def remaining
      d = (@started_at + @duration) - Time.now.to_i
      d > 0 ? d : 0
    end
  end
end
