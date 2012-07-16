require 'time'
require 'fileutils'
require 'forwardable'
require 'json'
require 'tamarillo/tomato'

module Tamarillo
  module Storage
    class JSON
      extend Forwardable

      DEFAULT_PATH = "#{ENV['HOME']}/.tamarillo/tomatoes.json"

      # Public: Initializes a new JSON storage.
      def initialize(params)
        @path = params.fetch('path') { DEFAULT_PATH }

        setup unless valid_file?
        load_tomatoes
      end

      # Public: Adds a tomato to be stored.
      def <<(tomato)
        return if include?(tomato)
        @tomatoes << tomato
      end

      # Public: Returns the most recent tomato.
      def latest
        sorted_tomatoes.first
      end

      # Public: Returns true if a tomato is stored.
      def_delegator :@tomatoes, :include?

      # Public: Returns the number of tomatoes stored.
      def_delegator :@tomatoes, :count

      # Public: Yields each tomato in reverse chronological order.
      def_delegator :sorted_tomatoes, :each

      # Public: Returns an array of tomatoes.
      def to_a
        sorted_tomatoes.clone
      end

      # Public: Writes the list of tomatoes to a JSON file.
      def write
        tomatoes = sorted_tomatoes.map { |t|
          h = t.dump
          h['started_at'] = h['started_at'].iso8601
          h
        }

        hash = { 'tomatoes' => tomatoes }

        write_json(hash)
      end

      private

      # Internal: Sorts tomato list in reverse chronological order.
      # XXX: This could be implemented with SortedSet, but it is only
      # available in Ruby 1.9.3
      def sorted_tomatoes
        @tomatoes.sort.reverse
      end

      # Internal: Loads tomatoes from JSON.
      def load_tomatoes
        json = File.read(@path)
        data = ::JSON.parse(json)
        tomatoes = data['tomatoes'].map { |h|
          h['started_at'] = Time.iso8601(h['started_at']).localtime
          Tomato.restore(h)
        }

        @tomatoes = tomatoes
      end

      # Internal: Returns true if storage file exists.
      def valid_file?
        File.size?(@path)
      end

      # Internal: Sets up a valid file if none exists.
      def setup
        default_hash = { 'tomatoes' => [] }
        write_json(default_hash)
      end

      # Internal: Writes to Tomatoes to JSON
      def write_json(hash)
        dir_path = File.dirname(@path)
        FileUtils.mkdir_p(dir_path)

        File.open(@path, 'w') do |f|
          f << ::JSON.generate(hash)
        end
      end

    end
  end
end
