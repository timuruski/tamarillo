require 'tamarillo'

module Tamarillo
  # Formats for tomatoes
  module Formats
    HUMAN = :human.freeze
    PROMPT = :prompt.freeze
  end

  # Public: This is intended to provide an environment for tomatoes to
  # work from. It integrates the storage, config and monitor into a
  # single coherant object.
  class Controller
    # Initializes a new controller.
    def initialize(config, storage)
      @config = config
      @storage = storage
    end

    # Public: Formats and returns the status of the current tomato.
    # Returns nil if no tomato is found.
    def status(format)
      tomato = @storage.latest
      return unless tomato && tomato.active?

      case format
      when Formats::HUMAN then format_approx_time(tomato.remaining)
      when Formats::PROMPT then format_prompt(tomato)
      else raise "Invalid format"
      end
    end

    # Public: Starts a new tomato if one is not already running.
    def start_new_tomato
      tomato = @storage.latest
      return if tomato && tomato.active?
      tomato = Tomato.new(@config.duration_in_seconds, Clock.now)
      @storage.write_tomato(tomato)

      tomato
    end

    # Public: Interrupts the current tomato if one is running.
    def interrupt_current_tomato
      tomato = @storage.latest
      return if tomato.nil?

      tomato.interrupt!
      @storage.write_tomato(tomato)
    end

    # Public: Returns the current config.
    def config
      @config
    end

    # Public: Updates the current config.
    def update_config(options = {})
      valid_config_options(options).each do |key,value|
        @config.send("#{key}=".to_sym, value)
      end

      @storage.write_config
    end

    private

    def valid_config_options(options)
      valid_keys = %w[duration notifier]
      options.select { |k,_| valid_keys.include?(k.to_s) }
    end

    def format_approx_time(time)
      minutes = (time / 60).round
      'About %d minutes' % minutes
    end

    def format_time(time)
      minutes = (time / 60).floor
      seconds = time % 60
      "%02d:%02d" % [minutes, seconds]
    end

    def format_prompt(tomato)
      [format_time(tomato.remaining), tomato.remaining, tomato.duration].join(' ')
    end

  end
end

