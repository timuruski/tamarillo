require 'tamarillo/tomato_file'
require 'fileutils'
require 'pathname'

module Tamarillo
  class TomatoBasket
    attr_reader :path

    def initialize(path)
      @path = File.expand_path(path)
      @pathname = Pathname.new(@path)
      FileUtils.mkdir_p(@pathname)
    end

    def save(tomato)
      tomato_path = @pathname.join(tomato_name(tomato))
      File.open(tomato_path, 'w') { |f| f << tomato_to_file(tomato) }
    end

    protected

    def tomato_name(tomato)
      'tomato'
    end

    def tomato_to_file(tomato)
      tomato_file = TomatoFile.new(tomato)
      [tomato_file.time_line,
       tomato_file.task_line,
       tomato_file.state_line].join("\n")
    end

  end
end
