# HallMonitor

[![Gem Version](https://badge.fury.io/rb/hall_monitor.svg)](https://badge.fury.io/rb/hall_monitor)
[![Build Status](https://semaphoreci.com/api/v1/freshly/spicerack/branches/master/badge.svg)](https://semaphoreci.com/freshly/spicerack)
[![Maintainability](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/maintainability)](https://codeclimate.com/github/Freshly/spicerack/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/test_coverage)](https://codeclimate.com/github/Freshly/spicerack/test_coverage)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hall_monitor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hall_monitor

## Usage

TODO: Write real instructions here

Something like:

```ruby
def expensive_and_critical_process
  # Important things go here
end
monitor_calls_to :expensive_and_critical_process, wait: 5.minutes
```

## Configuration

To configure HallMonitor for your application, add the following to an initializer:
```ruby
# initializers/hall_monitor.rb

HallMonitor::Configuration.configure do |config|

  # config.default_wait_time = 2.minutes
  
  # config.default_queue_name = :default
  
  # config.redis_db = 0
  
  # By default, this will revert to the REDIS_URL environment variable
  # config.redis_url = "redis://:pa55w0rd@your.host:4444/2"

end
```

## MonitorJob

HallMonitor uses ActiveJob delayed jobs to monitor and report on dead processes, so whichever queue processor your app uses needs to support delayed jobs. Some processor options are:
* Sidekiq (recommended)
* Resque (requires usage of the `resque-scheduler` gem)
* Delayed::Job
* Backburner

_Note: HallMonitor does not support the ActiveJob `:priority` option._

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hall_monitor.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
