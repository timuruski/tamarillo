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

    # Public: Returns the start time.
    attr_reader :started_at

    # Public: Initializes a new Tomato.
    #
    # duration - The length of the Tomato in seconds.
    # clock    - A Clock instance to keep track of elapsed time.
    def initialize(started_at, duration, clock = Time)
      @started_at = started_at
      @duration = duration
      @clock = clock
      @interrupted = false
    end

    # Public: Returns the Date the Tomato was started on.
    def date
      @started_at.to_date
    end

    # Public: Returns true if two Tomatoes share a start Time.
    def eql?(other)
      other.started_at == started_at &&
      other.duration == duration
    end

    # Public: Returns the number of seconds until completion.
    def remaining
      d = @duration - elapsed
      d > 0 ? d : 0
    end

    # Public: Returns the approximate number of minutes until
    # completetion.
    def approx_minutes_remaining
      (remaining / 60.0).round.to_i
    end

    # Public: Returns the number of seconds elapsed since start.
    def elapsed
      @clock.elapsed
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

    # Public: Returns an attributes hash suitable for persistence.
    def dump
      { 'started_at' => @started_at,
        'duration' => @duration,
        'interrupted' => @interrupted }
    end

    # Public: Restores a Tomato from a persisted hash.
    def self.restore(attrs, clock = Time)
      started_at = attrs['started_at']
      duration = attrs['duration']

      tomato = new(started_at, duration, clock)
      tomato.interrupt! if attrs['interrupted']
      tomato
    end

    protected

    # Internal: Returns the numbers of seconds since the start_time
    def elapsed
      @clock.now.to_i - @started_at.to_i
    end

  end
end
