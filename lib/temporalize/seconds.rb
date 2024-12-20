# frozen_string_literal: true

module Temporalize
  class Seconds
    attr_reader :seconds, :format_string

    def initialize(seconds, format_string = Formats::DEFAULT)
      @seconds = seconds.to_i
      @format_string = resolve_format(format_string)
    end

    def to_s
      if @format_string == :natural
        to_natural
      else
        format_duration
      end
    end

    private

    def format_duration
      time = Time.at(@seconds).utc
      time.strftime(@format_string)
    end

    def to_natural
      hours_val = hours
      minutes_val = minutes
      seconds_val = seconds_remainder

      parts = []
      parts << "#{hours_val} #{hours_val == 1 ? 'hour' : 'hours'}" if hours_val > 0
      parts << "#{minutes_val} #{minutes_val == 1 ? 'minute' : 'minutes'}" if minutes_val > 0
      parts << "#{seconds_val} #{seconds_val == 1 ? 'second' : 'seconds'}" if seconds_val > 0 || parts.empty?

      parts.join(' ')
    end

    def resolve_format(format)
      case format
      when Symbol
        if format == :natural
          :natural
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