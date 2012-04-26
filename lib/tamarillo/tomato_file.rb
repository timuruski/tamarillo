require 'time'

module Tamarillo
  # Internal: Represents a tomato in the filesystem.
  class TomatoFile
    FILENAME_FORMAT = '%Y%m%d%H%M%S'
    PATH_FORMAT = '%Y/%m%d'

    # Public: Initializes a new tomato file.
    #
    # tomato - A Tomato instance to serialize.
    def initialize(tomato)
      @tomato = tomato
    end

    # Public; Returns the filename of the Tomato.
    def name
      @tomato.started_at.strftime(FILENAME_FORMAT)
    end

    # Public: Returns a String path to the Tomato.
    def path
      self.class.path(@tomato.started_at)
    end
    
    # Public: Generate a path from a time.
    #
    # time - A Tomato's start time Date.
    #
    # Returns A String path generated from a Date.
    def self.path(time)
      dir = time.strftime(PATH_FORMAT)
      name = time.strftime(FILENAME_FORMAT)

      "#{dir}/#{name}"
    end

    # Public: Returns the serialized form of a Tomato.
    def content
      [time,task,state].join("\n")
    end

    private

    # Private: Returns the start time in ISO-8601 format.
    def time
      @tomato.started_at.iso8601
    end

    # Returns: The name of the task being worked on during the Tomato.
    def task
      "Some task I'm working on"
    end

    # Returns the state of the Tomato.
    def state
      @tomato.state.to_s
    end
  end
end
