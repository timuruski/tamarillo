module Tamarillo
  class Monitor
    # The time between checks.
    SLEEP_TIME = 0.3

    # Public: Initializes a new monitor.
    def initialize(params = {})
      @tomato = params[:tomato]
      @config = params[:config]
    end

    # Singleton class interface.
    class << self
      def start(tomato, config)
        monitor = new(tomato: tomato, config: config)
        monitor.start
      end

      # Public: Stops the currently active monitor, if it exists.
      def stop
        monitor = new
        monitor.stop
      end

      # Public: Removes stale pid-file if one exists.
      def cleanup
        monitor = new
        monitor.cleanup
      end

      # Public: Resolves the path to the monitor pid file.
      def pid_file_path
        tamarillo_path.join('monitor.pid')
      end

      # Public: Resolves the path to the tamarillo dir.
      def tamarillo_path
        path = ENV['TAMARILLO_PATH'] || "#{ENV['HOME']}/.tamarillo"
        Pathname.new(path)
      end
    end

    # Public: Starts watching a tomato for completion.
    def start
      return unless startable?

      @pid = fork do
        until @tomato.completed?
          sleep SLEEP_TIME
        end

        notifier = Notification.for(config.attributes['notifier'])
        # notifier = Tamarillo::Notification::Touch.new('~/Desktop/tamarillo')
        notifier.call

        cleanup
      end

      Process.detach(@pid)
      save
    end

    # Public: Stops the monitor and cleans up the pid-file.
    def stop
      return unless active?

      begin
        Process.kill('QUIT', pid)
      rescue Errno::ESRCH, Errno::EPERM
        # Silent kill.
      end

      cleanup
    end
    
    # Public: Returns the pid-file if it exists.
    def pid
      @pid ||= begin
        File.read(Monitor.pid_file_path).to_i if File.exist?(Monitor.pid_file_path)
      end
    end

    # Public: Returns true if pid exists and points to a process.
    def active?
      begin
        pid && Process.kill(0, pid)
      rescue
        false
      end
    end

    # Public: Returns true if a tomato and config are assigned.
    def startable?
      @tomato && @config && !active?
    end

    protected

    # Internal: Writes the monitor to a pid-file.
    def save
      return unless active?

      File.open(Monitor.pid_file_path, 'w') do |f|
        f << @pid
      end
    end

    # Internal: Cleans up pid-file.
    def cleanup
      return unless File.exist?(Monitor.pid_file_path)

      File.delete(Monitor.pid_file_path)
    end

  end
end
