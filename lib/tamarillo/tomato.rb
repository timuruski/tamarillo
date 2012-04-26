require 'date'

module Tamarillo
  # Public: A unit of work.
  #
  # A Tomato is a 'pomodoro', it keeps track of the amount of time you
  # have focused on a single task. It can be interrupted or completed.
  class Tomato
    module States
      ACTIVE = :active.freeze
      COMPLETED = :completed.freeze
      INTERRUPTED = :interrupted.freeze
    end

    attr_reader :duration

    def initialize(duration, clock)
      @duration = duration
      @clock = clock
    end

    def started_at
      @clock.start_time
    end

    def date
      @clock.start_date
    end

    def eql?(other)
      other.started_at == started_at || 
      super(other)
    end

    def remaining
      return 0 if @interrupted
      
      d = @duration - @clock.elapsed
      d > 0 ? d : 0
    end

    def interrupt!
      @interrupted = true
    end

    def active?
      States::ACTIVE == state
    end

    def completed?
      States::COMPLETED == state
    end

    def interrupted?
      States::INTERRUPTED == state
    end

    protected

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
