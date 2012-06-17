module Tamarillo
  module Notification
    class Speech
      SPEECH_COMMAND = %Q{say "Tomato complete."}

      # Public: executes the notification.
      def call
        system(SPEECH_COMMAND)
      end

    end
  end
end
