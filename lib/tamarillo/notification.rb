require 'tamarillo/notification/bell'
require 'tamarillo/notification/growl'
require 'tamarillo/notification/none'
require 'tamarillo/notification/speech'
require 'tamarillo/notification/touch'

module Tamarillo
  module Notification
    BELL = :bell.freeze
    GROWL = :growl.freeze
    NONE = :none.freeze
    SPEECH = :speech.freeze

    VALID = [BELL, GROWL, NONE, SPEECH]

    # Public: Returns a valid notification type.
    def self.valid!(value)
      value = value.to_s.downcase.to_sym
      VALID.include?(value) ? value : nil
    end

    def self.default
      BELL
    end

    # Public: Resolves a notification class.
    def self.for(type)
      case type
      when BELL then Bell.new
      when GROWL then Growl.new
      when SPEECH then Speech.new
      else None.new
      end
    end
  end
end
