# Temporalize

Temporalize provides a simple way to handle time durations in your Ruby applications. Whether you're dealing with video lengths, gameplay times, or any other duration data, Temporalize makes it easy to store, format, and display durations without the headache.

# Why Temporalize?

I created Temporalize while working on games.directory where we deal with tons of data from different game APIs. We kept running into the same problem - handling duration strings like "PT3H10M10S" from APIs, storing them efficiently in the database, and then formatting them nicely for display.
Converting these strings, storing them as integers, and formatting them back was becoming a tedious copy-paste job across our models. Inspired by how money-rails elegantly handles currency with monetize :price, I wanted something similarly clean for durations - just temporalize :duration_played and you're done.

# Features

- Dead simple API - just one line to handle a duration attribute
- Stores durations efficiently as integers (seconds or milliseconds)
- Automatically handles conversion between different formats

- Multiple output formats:

  - Default timestamp ("01:30:45")
  - Natural language ("1 hour 30 minutes 45 seconds")
  - Custom formats

- Plays nice with ActiveRecord
- Handles both seconds and milliseconds
- Zero dependencies (other than ActiveRecord)

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

## Usage

``` ruby
class Game < ApplicationRecord
  # Basic usage - assumes column name is duration_played_in_seconds
  temporalize :duration_played

  # Custom column name
  temporalize :total_time, column: :play_time_seconds

  # Handle millisecond precision
  temporalize :watch_time, column: :watch_time_in_ms

  # Custom format
  temporalize :completion_time, format: :natural  # "2 hours 30 minutes"
end

game = Game.new(duration_played: 3665)  # or "PT1H1M5S" from an API
game.duration_played.to_s  # => "01:01:05"
```
```ruby
class Game < ApplicationRecord
  temporalize :duration_played
  temporalize :total_time, column: :play_time_seconds
  temporalize :watch_time, column: :watch_time_in_ms, format: :natural
end

game = Game.new(duration_played: 3665)  # or "PT1H1M5S" from an API

# Returns a Temporalize::Seconds object
game.duration_played       # => #<Temporalize::Seconds:0x00007f9b8a8b0>

# Get formatted strings
game.duration_played.to_s  # => "01:01:05"

# Different format options
temporalize :duration_played, format: :natural
game.duration_played.to_s  # => "1 hour 1 minute 5 seconds"

temporalize :duration_played, format: :hh_mm_ss
game.duration_played.to_s  # => "01:01:05"

temporalize :duration_played, format: :compact
game.duration_played.to_s  # => "1h 1m 5s"

# Store in milliseconds
temporalize :watch_time, column: :watch_time_in_ms
game.watch_time = 1500              # 1.5 seconds
game.watch_time.to_s                # => "00:00:01"
game.watch_time_in_ms               # => 1500
```
The value is stored as an integer in your database but accessed through a Temporalize::Seconds object. This gives you the flexibility to:

Store the raw value efficiently in your database
Format it however you need in your views
Do calculations with the raw seconds when needed
Handle both second and millisecond precision

This is especially useful when dealing with APIs that send duration data in various formats - you can normalize everything to integers in the database while maintaining a clean interface for displaying values to users.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/temporalize. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/temporalize/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Temporalize project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/temporalize/blob/main/CODE_OF_CONDUCT.md).
