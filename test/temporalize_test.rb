# frozen_string_literal: true

require "test_helper"

class TemporalizeTest < Minitest::Test
  def setup
    @model = MyModel.create(duration_played_in_seconds: 3665, total_time_in_ms: 7200_000) # 1h 1m 5s, 2 hours in ms
  end

  def test_default_behavior
    @model.class.temporalize :duration_played

    assert_equal "01:01:05", @model.duration_played.to_s
    assert_equal 3665, @model.duration_played_in_seconds
  end

  def test_custom_column_name
    @model.class.temporalize :total_time, column: :total_time_in_ms

    assert_equal "02:00:00", @model.total_time.to_s
    assert_equal 7200_000, @model.total_time_in_ms
  end

  def test_custom_format
    @model.class.temporalize :duration_played, format: "%Hh %Mm %Ss"

    assert_equal "01h 01m 05s", @model.duration_played.to_s
  end

  def test_hh_mm_ss_format
    @model.class.temporalize :duration_played, format: :hh_mm_ss

    assert_equal "01:01:05", @model.duration_played.to_s
  end

  def test_configuration
    Temporalize.configure do |config|
      config.default_format = "%H:%M:%S"
    end

    @model.class.temporalize :duration_played

    assert_equal "01:01:05", @model.duration_played.to_s

    # Reset configuration to default
    Temporalize.configure do |config|
      config.default_format = Temporalize::Formats::DEFAULT
    end
  end

  def test_assignment
    @model.class.temporalize :duration_played

    @model.duration_played = Temporalize::Seconds.new(1800, Temporalize::Formats::DEFAULT) # 30 minutes
    assert_equal 1800, @model.duration_played_in_seconds

    @model.duration_played = 7200 # 2 hours
    assert_equal 7200, @model.duration_played_in_seconds
  end
end