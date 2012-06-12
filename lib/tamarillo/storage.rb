require 'tamarillo/clock'
require 'tamarillo/config'
require 'tamarillo/tomato'
require 'tamarillo/tomato_file'
require 'fileutils'
require 'pathname'

# Public: Stores tomatoes using the filesystem.
#
# This model represents a directory of Tomato files and configuration.
# It can read and write them, and find the latest one for the current
# day.
module Tamarillo
  class Storage
    # Returns: the String path to the storage directory.
    attr_reader :path
    # Returns: the Config for this storage.
    # Used to set the duration when reading tomatoes in.
    attr_reader :config

    # Public: Initialize a new storage object.
    def initialize(path, config = nil)
      @config = config || Tamarillo::Config.new
      @path = Pathname.new(path)
      FileUtils.mkdir_p(@path)
    end

    # Public: Write the config to the filesystem.
    #
    # Returns the Pathname to the config that was written.
    def write_config
      File.open(config_path, 'w') { |f| f << @config.to_yaml }
    end

    # Public: Write a tomato to the filesystem.
    #
    # tomato - A Tomato instance.
    #
    # Returns the Pathname to the tomato that was written.
    def write_tomato(tomato)
      tomato_file = TomatoFile.new(tomato)
      tomato_path = @path.join(tomato_file.path)
      FileUtils.mkdir_p(File.dirname(tomato_path))
      File.open(tomato_path, 'w') { |f| f << tomato_file.content }

      tomato_path
    end

    # Public: Read a tomato from the filesystem.
    #
    # path - A String path to a tomato file.
    #
    # Returns a Tomato instance if found, nil if not found.
    def read_tomato(path)
      return unless File.exist?(path)

      data = File.readlines(path)
      start_time = Time.iso8601(data[0]).localtime
      state = data[2]

      clock = Clock.new(start_time)
      duration = config.duration_in_seconds
      tomato = Tomato.new(duration, clock)
      tomato.interrupt! if state == 'interrupted'
      
      tomato
    end

    # Public: Returns a Tomato instance if one exists.
    def latest
      return unless File.directory?(tomato_dir)
      # p Dir.glob(tomato_dir.join('*'))

      # XXX tomato_dir.to_s because FakeFS chokes on Pathname.
      if latest_name = Dir.glob(tomato_dir.join('*')).sort.last
        read_tomato(latest_name)
      end
    end

    private

    # Private: Returns a Pathname to the config.
    def config_path
      @path.join('config.yml')
    end

    # Private: Returns a Pathname to the current day.
    def tomato_dir
      base_path = File.dirname(TomatoFile.path(Time.now))
      @path.join(base_path)
    end

  end
end
