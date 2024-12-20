# frozen_string_literal: true

require_relative "temporalize/version"
require_relative "temporalize/formats"
require_relative "temporalize/configuration"
require_relative "temporalize/seconds"

module Temporalize
  class Error < StandardError; end

  def self.temporalize(klass, attribute, **options)
    column = options[:column] || "#{attribute}_in_seconds".to_sym
    format_string = options[:format] || configuration.default_format

    klass.class_eval do
      define_method(attribute) do
        seconds = public_send(column)
        return nil if seconds.nil?

        # Only convert from milliseconds if the column name suggests it contains milliseconds
        seconds = seconds / 1000 if column.to_s.include?("_in_ms") || column.to_s.include?("_milliseconds")
        Temporalize::Seconds.new(seconds, format_string)
      end

      define_method("#{attribute}=") do |value|
        seconds = case value
                  when Temporalize::Seconds then value.seconds
                  when Numeric then value.to_i
                  when nil then nil
                  else
                    raise ArgumentError, "Invalid duration value: #{value.inspect}"
                  end

        # Only convert to milliseconds if the column name suggests it should store milliseconds
        seconds = seconds * 1000 if (column.to_s.include?("_in_ms") || column.to_s.include?("_milliseconds")) && !seconds.nil?
        public_send("#{column}=", seconds)
      end
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end
end