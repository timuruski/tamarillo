module Tamarillo
  module Notification
    class Touch
      # Public: initializes a new notifier.
      def initialize(path)
        @path = File.expand_path(path)
      end

      # Public: executes the notification.
      def call
        system("touch #{@path}")
      end

    end
  end
end
