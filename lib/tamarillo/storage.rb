require 'tamarillo/clock'
require 'tamarillo/tomato'
require 'tamarillo/tomato_file'
require 'fileutils'
require 'pathname'

module Tamarillo
  class Storage
    attr_reader :path

    def initialize(path)
      @path = File.expand_path(path)
      @pathname = Pathname.new(@path)
      FileUtils.mkdir_p(@pathname)
    end

    def write(tomato)
      tomato_file = TomatoFile.new(tomato)
      tomato_path = @pathname.join(tomato_file.name)
      File.open(tomato_path, 'w') { |f| f << tomato_file.content }
    end

    def read(path)
      data = File.readlines(path)
      start_time = Time.iso8601(data[0])

      
      clock = Clock.new(start_time)
      Tomato.new(25 * 60, clock)
    end

  end
end
