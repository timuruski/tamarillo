module Tamarillo
  module Notification
    # Public: Provides a no-op for the notification system.
    class None

      # Public: executes the notification.
      def call
        # NO-OP
      end

    end
  end
end
