# frozen_string_literal: true

require "active_support/concern"

module Temporalize
  module Configuration
    mattr_accessor :default_format, default: Formats::DEFAULT
  end
end