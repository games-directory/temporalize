# frozen_string_literal: true

require "active_support/concern"

module Temporalize
  class Configuration
    attr_accessor :default_format

    def initialize
      @default_format = Formats::DEFAULT
    end
  end
end