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
      FileUtils.touch(tomato_path)
    end

    protected

    def tomato_name(tomato)
      'tomato'
    end

  end
end
