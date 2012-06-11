module Tamarillo
  module Notification
    class Growl
      GROWL_COMMAND = %Q{growlnotify -m "Tomato complete!"}

      # Public: executes the notification.
      def call
        system(GROWL_COMMAND)
      end

    end
  end
end
