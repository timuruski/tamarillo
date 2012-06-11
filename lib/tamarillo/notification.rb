require 'tamarillo/notification/bell'
require 'tamarillo/notification/growl'
require 'tamarillo/notification/speech'

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

    # Public: Resolves a notification class.
    def self.for(type)
      case type
      when BELL then Bell.new
      when GROWL then Growl.new
      when SPEECH then Speech.new
      end
    end
  end
end
