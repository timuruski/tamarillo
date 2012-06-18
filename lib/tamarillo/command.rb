require 'tamarillo'

module Tamarillo
  class Command
    DEFAULT_PATH = '~/.tamarillo'
    DEFAULT_COMMAND = 'status'

    HELP_TEXT = <<-EOS
Tamarillo v#{VERSION}

Commands:

$ tam status [--prompt]

Displays remainder of current pomodoro, use the prompt switch
to render a space-separated format for prompt integration. This
is the default command.

eg. 12:00 720 900


$ tam start

Starts a new pomodoro if none in progress.


$ tam stop
$ tam interrupt

Stops the current pomodoro if in progress.


$ tam config
$ tam config [duration=MINUTES]
$ tam config [notifier=TYPE]

Displays the current configuration, use to change then duration of 
each pomodoro in minutes or the type of notifier used. 

Notifiers: growl, speech, bell
EOS

    VALID_COMMANDS = %w[help status config start stop interrupt]

    def initialize
      config = Tamarillo::Config.load(config_path)
      storage = Storage.new(tamarillo_path, config)
      @controller = Controller.new(config, storage)
    end

    def execute(*args)
      command = parse_command_name!(args)
      send(command.to_sym, *args.drop(1))
    end

    def help(*args)
      puts HELP_TEXT
    end

    def status(*args)
      format = Formats::HUMAN
      format = Formats::PROMPT if args.include?('--prompt')

      status = @controller.status(format)
      puts status unless status.nil?
    end

    def start(*args)
      tomato = @controller.start_new_tomato
      status unless tomato.nil?
    end

    def interrupt(*args)
      @controller.interrupt_current_tomato
    end
    alias :stop :interrupt

    def config(*args)
      params = Hash[args.map { |pair| pair.split('=', 2) }]
      @controller.update_config(params)
      puts @controller.config.to_yaml
    end

    private

    def parse_command_name!(args)
      name = args.first || DEFAULT_COMMAND
      name = 'help' if name =~ /^(-h|--help)/
      unless VALID_COMMANDS.include?(name)
        puts "Invalid command '#{name}'"
        exit 1
      end

      name
    end

    def tamarillo_path
      path = ENV['TAMARILLO_PATH'] || DEFAULT_PATH
      Pathname.new(File.expand_path(path))
    end

    def config_path
      tamarillo_path.join('config.yml')
    end

  end
end

