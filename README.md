# RailsGraylog

This gem facilitates a logging mechanism to Graylog through Rails logger.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_graylog'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_graylog

## Usage

Make sure the environment variables GRAYLOG_HOST and GRAYLOG_PORT are set correctly.

    require 'rails_graylog'

In Rails configuration:

```ruby
exception_handler = Proc.new do |exception|
  ExceptionNotification.notify_exception(exception)
end

amqp_notifier = RailsGraylog::AmqpNotifier.new(queue_name: 'logging', channel: Mq.channel, exception_handler: exception_handler, durable: true)
Rails.config.logger = RailsGraylog::Logger.new(amqp_notifier)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cgservices/rails_graylog.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
