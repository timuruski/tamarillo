module Tamarillo
  class TomatoFile
    FILENAME_FORMAT = '%Y%m%d%H%M%S'
    def initialize(tomato)
      @tomato = tomato
    end
    
    def name
      @tomato.started_at.strftime(FILENAME_FORMAT)
    end

    def time_line
      @tomato.started_at.to_s
    end

    def task_line
      'Some task I\'m working on'
    end

    def state_line
      @tomato.state.to_s
    end
  end
end
