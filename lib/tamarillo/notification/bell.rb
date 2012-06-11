module Tamarillo
  module Notification
    class Bell
      CHIME_COUNT = 3
      CHIME_COMMAND = 'tput bel; sleep 0.2'

      # Public: executes the notification.
      def call
        cmd = (1..CHIME_COUNT).map { CHIME_COMMAND }.join(';')
        system(cmd)
      end

    end
  end
end
