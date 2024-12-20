# frozen_string_literal: true

module Temporalize
  module Formats
    NATURAL = :natural  # Special format for human-readable output

    DEFAULT = "%H:%M:%S".freeze
    HH_MM_SS = "%H:%M:%S".freeze
    HOURS_MINUTES = "%H:%M".freeze
    MINUTES_SECONDS = "%M:%S".freeze
    VERBOSE = "%H hours %M minutes %S seconds".freeze
    COMPACT = "%Hh %Mm %Ss".freeze

  end
end
