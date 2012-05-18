require 'tamarillo'

module Tamarillo
  class Command
    DEFAULT_PATH = '~/.tamarillo'
    DEFAULT_COMMAND = 'status'

    def initialize
      config = Tamarillo::Config.load(config_path)
      storage = Storage.new(tamarillo_path, current_config)
      @controller = Controller.new(config, storage)
    end

    def execute(*args)
      begin
        command = command_name(args.first)
        send(command.to_sym, *args.drop(1))
      rescue NoMethodError
        puts "Invalid command '#{command}'"
        exit 1
      end
    end

    def status(*args)
      format = Formats::HUMAN
      format = Formats::PROMPT if args.include?('--prompt')

      status = @controller.status(format)
      puts status unless status.nil?
    end

    def start(*args)
      tomato = storage.latest
      return if tomato && tomato.active?

      clock = Clock.new(Time.now)
      duration = current_config.duration_in_seconds
      tomato = Tomato.new(duration, clock)
      storage.write(tomato)

      puts format_approx_time(tomato.remaining)
    end

    def interrupt(*args)
      if tomato = storage.latest
        tomato.interrupt!
        path = storage.write(tomato)
      end
    end

    def config(*args)
      if args.any?
        args.each do |arg|
          name, value = arg.split('=',2)
          current_config.send("#{name}=".to_sym, value.strip)
        end
        current_config.write(config_path)
      end

      puts current_config.to_yaml
    end

    private

    def command_name(name)
      name || DEFAULT_COMMAND
    end

    def storage
      @storage ||= Storage.new(tamarillo_path, current_config)
    end

    def current_config
      @config ||= Tamarillo::Config.load(config_path)
    end

    def tamarillo_path
      path = ENV['TAMARILLO_PATH'] || DEFAULT_PATH
      Pathname.new(File.expand_path(path))
    end

    def config_path
      tamarillo_path.join('config.yml')
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
      puts [format_time(tomato.remaining), tomato.remaining, tomato.duration].join(' ')
    end
  end
end

