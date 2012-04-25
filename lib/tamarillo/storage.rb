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
      @storage_path = Pathname.new(@path)
      FileUtils.mkdir_p(@storage_path)
    end

    def write(tomato)
      tomato_file = TomatoFile.new(tomato)
      tomato_path = @storage_path.join(tomato_file.path)
      FileUtils.mkdir_p(File.dirname(tomato_path))
      File.open(tomato_path, 'w') { |f| f << tomato_file.content }
    end

    def read(path)
      data = File.readlines(path)
      start_time = Time.iso8601(data[0])

      clock = Clock.new(start_time)
      Tomato.new(25 * 60, clock)
    end

    def latest
      return unless File.directory?(tomato_dir)

      if latest_name = Dir.new(tomato_dir.to_s).sort.last
        read(tomato_dir.join(latest_name))
      end
    end

    private

    def tomato_dir
      base_path = File.dirname(TomatoFile.path(Time.now))
      @storage_path.join(base_path)
    end

  end
end
