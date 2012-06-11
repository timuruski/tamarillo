module Tamarillo
  module Notification
    BELL = :bell.freeze
    GROWL = :growl.freeze
    SPEECH = :speech.freeze

    VALID = [BELL, GROWL, SPEECH]

    # Public: Returns a valid notification type.
    def self.valid!(value)
      value = value.to_s.downcase.to_sym
      VALID.include?(value) ? value : BELL
    end
  end
end
