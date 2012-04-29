require 'tamarillo'

module Tamarillo
  class Command
    # DEFAULT_PATH = '~/.tamarillo'
    DEFAULT_PATH = 'tmp/tamarillo'
    DEFAULT_COMMAND = 'status'

    def execute(*args)
      # puts "#{tamarillo_path}"
      command = command_name(args.first)

      @storage = Storage.new(tamarillo_path)
      send(command.to_sym)
    end

    def status
      if tomato = storage.latest
        puts tomato.remaining
      else
        puts "No tomatoes in progress."
      end
    end

    def start
      tomato = storage.latest
      return if tomato && tomato.active?

      clock = Clock.new(Time.now)
      tomato = Tomato.new(25 * 60, clock)
      storage.write(tomato)

      puts tomato.remaining
    end

    def config
      puts "Doing config"
    end

    private

    def storage
      @storage ||= Storage.new(tamarillo_path)
    end

    def tamarillo_path
      path = ENV['TAMARILLO_PATH'] || DEFAULT_PATH
      File.expand_path(path)
    end

    def command_name(name)
      name || DEFAULT_COMMAND
    end
  end
end

