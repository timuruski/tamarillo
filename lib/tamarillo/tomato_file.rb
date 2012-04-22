require 'time'

module Tamarillo
  class TomatoFile
    FILENAME_FORMAT = '%Y%m%d%H%M%S'

    def initialize(tomato)
      @tomato = tomato
    end

    def name
      @tomato.started_at.strftime(FILENAME_FORMAT)
    end

    def content
      [time,task,state].join("\n")
    end

    private

    def time
      @tomato.started_at.iso8601
    end

    def task
      "Some task I'm working on"
    end

    def state
      @tomato.state.to_s
    end
  end
end
