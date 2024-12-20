# test/test_helper.rb (No changes needed here)
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "temporalize"

require "minitest/autorun"
require 'active_record'
require 'sqlite3'

# Set up a dummy in-memory database for testing
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

# Define a simple ActiveRecord model for testing
class MyModel < ActiveRecord::Base
  self.table_name = 'my_models'
  def self.temporalize(*args)
    Temporalize.temporalize(self, *args)
  end

  def self.undefine_temporalize_methods(attribute, column)
    undef_method(attribute) if method_defined?(attribute)
    undef_method("#{attribute}=") if method_defined?("#{attribute}=")
    undef_method(column) if method_defined?(column)
    undef_method("#{column}=") if method_defined?("#{column}=")
  end
end

# Create the table for the dummy model
ActiveRecord::Schema.define do
  create_table :my_models do |t|
    t.integer :duration_played_in_seconds
    t.integer :total_time_in_ms
  end
end

class TemporalizeTest < Minitest::Test
  def setup
    @model = MyModel.create(duration_played_in_seconds: 3665, total_time_in_ms: 7200_000) # 1h 1m 5s, 2 hours in ms
  end

  def teardown
    MyModel.undefine_temporalize_methods(:duration_played, :duration_played_in_seconds)
    MyModel.undefine_temporalize_methods(:total_time, :total_time_in_ms)
  end

  def test_default_behavior
    @model.class.temporalize(:duration_played) # No options needed here

    assert_equal "01:01:05", @model.duration_played.to_s
    assert_equal 3665, @model.duration_played_in_seconds
  end

  def test_custom_column_name
    @model.class.temporalize(:total_time, column: :total_time_in_ms) # Options as a hash

    assert_equal "02:00:00", @model.total_time.to_s
    assert_equal 7200_000, @model.total_time_in_ms
  end

  def test_custom_format
    @model.class.temporalize(:duration_played, format: "%Hh %Mm %Ss") # Options as a hash

    assert_equal "01h 01m 05s", @model.duration_played.to_s
  end

  def test_hh_mm_ss_format
    @model.class.temporalize(:duration_played, format: :hh_mm_ss) # Options as a hash

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