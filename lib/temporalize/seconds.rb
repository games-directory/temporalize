# lib/temporalize/seconds.rb
# frozen_string_literal: true

module Temporalize
  class Seconds
    attr_reader :seconds, :format_string

    def initialize(seconds, format_string = Formats::DEFAULT)
      @seconds = seconds.to_i.abs  # Handle negative values by taking absolute value
      @format_string = resolve_format(format_string)
    end

    def to_s
      if @format_string == :natural
        to_natural
      elsif @format_string == :minutes_seconds
        format_minutes_seconds
      else
        format_duration
      end
    end

    private

    def format_duration
      time = Time.at(@seconds).utc
      time.strftime(@format_string)
    end

    def format_minutes_seconds
      total_minutes = (@seconds / 60.0).floor
      remaining_seconds = @seconds % 60
      format("%02d:%02d", total_minutes, remaining_seconds)
    end

    def to_natural
      parts = []

      if @milliseconds
        ms = @milliseconds % 1000
        parts.unshift("#{ms} milliseconds") if ms > 0
      end

      if @seconds > 0 || parts.empty?
        hours_val = hours
        minutes_val = minutes
        seconds_val = seconds_remainder

        parts.unshift("#{hours_val} #{hours_val == 1 ? 'hour' : 'hours'}") if hours_val > 0
        parts.unshift("#{minutes_val} #{minutes_val == 1 ? 'minute' : 'minutes'}") if minutes_val > 0
        parts.unshift("#{seconds_val} #{seconds_val == 1 ? 'second' : 'seconds'}") if seconds_val > 0 || parts.empty?
      end

      parts.join(' ')
    end

    def resolve_format(format)
      case format
      when Symbol
        if format == :natural
          :natural
        elsif format == :minutes_seconds
          :minutes_seconds
        else
          Formats.const_get(format.to_s.upcase)
        end
      else
        format
      end
    end

    def hours
      @seconds / 3600
    end

    def minutes
      (@seconds % 3600) / 60
    end

    def seconds_remainder
      @seconds % 60
    end
  end
end