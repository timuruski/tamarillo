require 'fileutils'

module Tamarillo
  class TomatoBasket
    attr_reader :path
    def initialize(path)
      @path = File.expand_path(path)
      FileUtils.mkdir_p(path)
    end

  end
end
