require 'tamarillo'

module Tamarillo
  class Command
    DEFAULT_PATH = '~/.tamarillo'
    DEFAULT_COMMAND = 'status'

    def execute(*args)
      # puts "#{tamarillo_path}"
      command = command_name(args.first)

      @storage = Storage.new(tamarillo_path)
      send(command.to_sym, *args.drop(1))
    end

    def status(*args)
      if tomato = storage.latest
        puts format_time(tomato.remaining)
      end
    end

    def start(*args)
      tomato = storage.latest
      return if tomato && tomato.active?

      clock = Clock.new(Time.now)
      tomato = Tomato.new(25 * 60, clock)
      storage.write(tomato)

      puts format_time(tomato.remaining)
    end

    def config(*args)
      p args
      if args.any?
        args.each do |arg|
          name, value = arg.split('=',2)
          _config.send("#{name}=".to_sym, value.strip)
        end
        _config.write(config_path)
      end

      puts _config.to_yaml
    end

    private

    def command_name(name)
      name || DEFAULT_COMMAND
    end

    def storage
      @storage ||= Storage.new(tamarillo_path)
    end

    def _config
      @config ||= Tamarillo::Config.load(config_path)
    end

    def tamarillo_path
      path = ENV['TAMARILLO_PATH'] || DEFAULT_PATH
      Pathname.new(File.expand_path(path))
    end

    def config_path
      tamarillo_path.join('config.yml')
    end

    def format_time(time)
      minutes = (time / 60).floor
      seconds = time % 60
      "%02d:%02d" % [minutes, seconds]
    end

  end
end

