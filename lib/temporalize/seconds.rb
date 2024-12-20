# lib/temporalize/seconds.rb (updated format_as_hh_mm_ss)
# frozen_string_literal: true

module Temporalize
  module Formats
    DEFAULT = "%H:%M:%S".freeze
    HH_MM_SS = "%H:%M:%S".freeze
  end

  class Seconds
    include Formats

    attr_reader :seconds, :format_string

    def initialize(seconds, format_string)
      @seconds = seconds
      @format_string = format_string
    end

    def to_s
      format_duration
    end

    def format_duration
      case @format_string
      when :hh_mm_ss, HH_MM_SS
        format_as_hh_mm_ss
      else
        format_with_custom_format
      end
    end

    def format_as_hh_mm_ss
      format(HH_MM_SS, hours: hours, minutes: minutes, seconds: seconds_remainder) # Use keyword arguments
    end

    def format_with_custom_format
      format(@format_string, hours: hours, minutes: minutes, seconds: seconds_remainder)
    end

    private

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