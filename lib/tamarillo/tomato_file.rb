require 'time'

module Tamarillo
  class TomatoFile
    FILENAME_FORMAT = '%Y%m%d%H%M%S'
    PATH_FORMAT = '%Y/%m%d'

    def initialize(tomato)
      @tomato = tomato
    end

    def name
      @tomato.started_at.strftime(FILENAME_FORMAT)
    end

    def path
      self.class.path(@tomato.started_at)
    end
    
    def self.path(time)
      dir = time.strftime(PATH_FORMAT)
      name = time.strftime(FILENAME_FORMAT)

      "#{dir}/#{name}"
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
