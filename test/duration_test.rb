# test/temporalize/duration_test.rb
# frozen_string_literal: true

require "test_helper"

class DurationTest < Minitest::Test
  def setup
    @model = MyModel.new
  end

  def teardown
    MyModel.undefine_temporalize_methods(:duration_played, :duration_played_in_seconds)
    MyModel.undefine_temporalize_methods(:total_time, :total_time_in_ms)
  end

  def test_natural_format
    @model.class.temporalize :duration_played, format: :natural

    test_cases = {
      0 => "0 seconds",
      1 => "1 second",
      30 => "30 seconds",
      60 => "1 minute",
      90 => "1 minute 30 seconds",
      3600 => "1 hour",
      3660 => "1 hour 1 minute",
      3661 => "1 hour 1 minute 1 second",
      7200 => "2 hours",
      7805 => "2 hours 10 minutes 5 seconds",
      86400 => "24 hours"
    }

    test_cases.each do |seconds, expected|
      @model.duration_played_in_seconds = seconds
      assert_equal expected, @model.duration_played.to_s, "Failed for #{seconds} seconds"
    end
  end

  def test_hh_mm_ss_format
    @model.class.temporalize :duration_played, format: :hh_mm_ss

    test_cases = {
      0 => "00:00:00",
      30 => "00:00:30",
      90 => "00:01:30",
      3600 => "01:00:00",
      3661 => "01:01:01",
      7805 => "02:10:05"
    }

    test_cases.each do |seconds, expected|
      @model.duration_played_in_seconds = seconds
      assert_equal expected, @model.duration_played.to_s, "Failed for #{seconds} seconds"
    end
  end

  def test_hours_minutes_format
    @model.class.temporalize :duration_played, format: :hours_minutes

    test_cases = {
      0 => "00:00",
      30 => "00:00",  # Rounds down
      90 => "00:01",
      3600 => "01:00",
      3661 => "01:01",
      7805 => "02:10"
    }

    test_cases.each do |seconds, expected|
      @model.duration_played_in_seconds = seconds
      assert_equal expected, @model.duration_played.to_s, "Failed for #{seconds} seconds"
    end
  end

  def test_minutes_seconds_format
    @model.class.temporalize :duration_played, format: :minutes_seconds

    test_cases = {
      0 => "00:00",
      30 => "00:30",
      90 => "01:30",
      3600 => "60:00",
      3661 => "61:01",
      7805 => "130:05"
    }

    test_cases.each do |seconds, expected|
      @model.duration_played_in_seconds = seconds
      assert_equal expected, @model.duration_played.to_s, "Failed for #{seconds} seconds"
    end
  end

  def test_verbose_format
    @model.class.temporalize :duration_played, format: :verbose

    test_cases = {
      3661 => "01 hours 01 minutes 01 seconds",
      7805 => "02 hours 10 minutes 05 seconds"
    }

    test_cases.each do |seconds, expected|
      @model.duration_played_in_seconds = seconds
      assert_equal expected, @model.duration_played.to_s, "Failed for #{seconds} seconds"
    end
  end

  def test_compact_format
    @model.class.temporalize :duration_played, format: :compact

    test_cases = {
      3661 => "01h 01m 01s",
      7805 => "02h 10m 05s"
    }

    test_cases.each do |seconds, expected|
      @model.duration_played_in_seconds = seconds
      assert_equal expected, @model.duration_played.to_s, "Failed for #{seconds} seconds"
    end
  end

  def test_custom_format
    @model.class.temporalize :duration_played, format: "%H-%M-%S"

    test_cases = {
      3661 => "01-01-01",
      7805 => "02-10-05"
    }

    test_cases.each do |seconds, expected|
      @model.duration_played_in_seconds = seconds
      assert_equal expected, @model.duration_played.to_s, "Failed for #{seconds} seconds"
    end
  end

  def test_milliseconds_with_natural_format
    @model.class.temporalize :total_time, column: :total_time_in_ms, format: :natural

    test_cases = {
      1000 => "1 second",
      1500 => "1 second 500 milliseconds",
      60000 => "1 minute",
      61500 => "1 minute 1 second 500 milliseconds"
    }

    test_cases.each do |ms, expected|
      @model.total_time_in_ms = ms
      assert_equal expected, @model.total_time.to_s, "Failed for #{ms} milliseconds"
    end
  end

  def test_edge_cases
    @model.class.temporalize :duration_played, format: :natural

    # Test nil values
    @model.duration_played_in_seconds = nil
    assert_nil @model.duration_played

    # Test negative values (if supported)
    @model.duration_played_in_seconds = -3600
    assert_equal "1 hour", @model.duration_played.to_s

    # Test very large values
    @model.duration_played_in_seconds = 356 * 24 * 3600  # ~1 year
    assert_equal "8544 hours", @model.duration_played.to_s
  end
end