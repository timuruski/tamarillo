require 'date'

module Tamarillo
  # Public: A unit of work.
  #
  # A Tomato is a 'pomodoro', it keeps track of the amount of time you
  # have focused on a single task. It can be interrupted or completed.
  class Tomato
    # Internal: A set of valid states a Tomato can be in.
    module States
      ACTIVE = :active.freeze
      COMPLETED = :completed.freeze
      INTERRUPTED = :interrupted.freeze
    end

    # Public: Gets/Sets the length of the tomato in seconds.
    attr_accessor :duration

    # Public: Initializes a new Tomato.
    #
    # duration - The length of the Tomato in seconds.
    # clock    - A Clock instance to keep track of elapsed time.
    def initialize(duration, clock)
      @duration = duration
      @clock = clock
    end

    # Public: Returns the starting Time of the Tomato.
    def started_at
      @clock.start_time
    end

    # Public: Returns the Date the Tomato was started on.
    def date
      @clock.start_date
    end

    # Public: Returns true if two Tomatoes share a start Time.
    def eql?(other)
      other.started_at == started_at ||
      super(other)
    end

    # Public: Returns the number of seconds until completion.
    def remaining
      return 0 if @interrupted

      d = @duration - @clock.elapsed
      d > 0 ? d : 0
    end

    # Public: Marks the tomato as interrupted.
    #
    # Returns the Tomato.
    def interrupt!
      @interrupted = true
      self
    end

    # Public: Returns true if the Tomato has not been completed or
    # interrupted.
    def active?
      States::ACTIVE == state
    end

    # Public: Returns true if the elapsed Time matches the duration.
    def completed?
      States::COMPLETED == state
    end

    # Public: Returns true if the Tomato has been interrupted.
    def interrupted?
      States::INTERRUPTED == state
    end

    # Public: Returns which state the Tomato is in.
    #
    # I'd rather keep this internal, but the storage system needs to
    # know what state the tamato was in when it was written.
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
