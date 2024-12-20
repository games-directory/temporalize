# lib/temporalize.rb
# frozen_string_literal: true

require_relative "temporalize/version"
require_relative "temporalize/seconds"

module Temporalize
  class Error < StandardError; end

  def self.temporalize(klass, attribute, column: nil, format: Temporalize::Formats::DEFAULT)
    column ||= "#{attribute}_in_seconds".to_sym
    format_string = format == Formats::DEFAULT ? configuration.default_format : format

    klass.class_eval do
      define_method(attribute) do
        seconds = read_attribute(column)
        seconds = seconds / 1000 if column.to_s.end_with?("_in_ms")
        Temporalize::Seconds.new(seconds, format_string)
      end

      define_method("#{attribute}=") do |value|
        seconds = value.is_a?(Temporalize::Seconds) ? value.seconds : value
        seconds = seconds * 1000 if column.to_s.end_with?("_in_ms")
        write_attribute(column, seconds)
      end

      define_method(column) do
        read_attribute(column)
      end

      define_method("#{column}=") do |value|
        write_attribute(column, value)
      end
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :default_format

    def initialize
      @default_format = Formats::DEFAULT
    end
  end
end