
require "test_helper"

class ColumnNamesTest < Minitest::Test
  def setup
    # Drop the table if it exists
    ActiveRecord::Base.connection.drop_table(:duration_models) if ActiveRecord::Base.connection.table_exists?(:duration_models)

    ActiveRecord::Schema.define do
      create_table :duration_models do |t|
        t.integer :play_time
        t.integer :watch_duration_ms
        t.integer :time_played_milliseconds
        t.integer :custom_duration_column
        t.integer :listen_time_in_seconds
      end
    end

    @model_class = Class.new(ActiveRecord::Base) do
      self.table_name = 'duration_models'

      def self.temporalize(*args, **options)
        Temporalize.temporalize(self, *args, **options)
      end
    end
  end

  def teardown
    ActiveRecord::Base.connection.drop_table(:duration_models)
  end

  def test_custom_column_names
    # Standard name
    @model_class.temporalize :duration, column: :custom_duration_column
    record = @model_class.new(custom_duration_column: 3665)
    assert_equal "01:01:05", record.duration.to_s

    # Column with 'milliseconds' in name
    @model_class.temporalize :watch_time, column: :time_played_milliseconds
    record = @model_class.new(time_played_milliseconds: 3665000)
    assert_equal "01:01:05", record.watch_time.to_s

    # Column with 'ms' in name
    @model_class.temporalize :viewing_time, column: :watch_duration_ms
    record = @model_class.new(watch_duration_ms: 3665000)
    assert_equal "01:01:05", record.viewing_time.to_s

    # Simple column name
    @model_class.temporalize :play_duration, column: :play_time
    record = @model_class.new(play_time: 3665)
    assert_equal "01:01:05", record.play_duration.to_s
  end

  def test_default_column_name_convention
    @model_class.temporalize :listen_time
    record = @model_class.new(listen_time_in_seconds: 3665)
    assert_equal "01:01:05", record.listen_time.to_s
  end

  def test_millisecond_value_assignment
    # Test assigning values to millisecond columns
    @model_class.temporalize :watch_time, column: :watch_duration_ms
    record = @model_class.new

    # Assigning seconds value
    record.watch_time = 3665
    assert_equal 3665000, record.watch_duration_ms

    # Assigning a Seconds instance
    record.watch_time = Temporalize::Seconds.new(7200)
    assert_equal 7200000, record.watch_duration_ms
  end

  def test_regular_seconds_value_assignment
    # Test assigning values to regular second columns
    @model_class.temporalize :play_duration, column: :play_time
    record = @model_class.new

    # Assigning seconds value
    record.play_duration = 3665
    assert_equal 3665, record.play_time

    # Assigning a Seconds instance
    record.play_duration = Temporalize::Seconds.new(7200)
    assert_equal 7200, record.play_time
  end
end