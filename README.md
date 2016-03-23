# Ruboty::SqsMonitor

[Ruboty](https://github.com/r7kamura/ruboty) plug-in to monitor AWS SQS.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruboty-sqs_monitor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruboty-sqs_monitor

## ENV
```
SQS_REGION            - AWS region for SQS (default: ENV["AWS_REGION"])
SQS_ACCESS_KEY_ID     - AWS access key for SQS (default: ENV["AWS_ACCESS_KEY_ID"])
SQS_SECRET_ACCESS_KEY - AWS secret key for SQS (default: ENV["AWS_SECRET_ACCESS_KEY"])
SQS_METRICS           - Metric list to monitor (default: "ApproximateNumberOfMessagesDelayed,ApproximateNumberOfMessagesNotVisible,ApproximateNumberOfMessagesVisible,NumberOfEmptyReceives,NumberOfMessagesDeleted,NumberOfMessagesReceived,NumberOfMessagesSent,SentMessageSize")
SQS_TREND_SEPARATOR   - Trend separator (default: ' ')
```

## Usage
```
$ bundle exec ruboty
Type `exit` or `quit` to end the session.
> @ruboty help sqs
ruboty /add sqs (?<name>.+) (?<real_name>.+)/ - Add a new alias name of sqs queue to monitor.
ruboty /delete sqs (?<name>.+)/ - Delete a alias name of sqs queue to monitor.
ruboty /list sqs queues\z/ - List all sqs queue names.
ruboty /show sqs state (?<from>(?:(?!last).)+) (?<to>.+)/ - Show all sqs queue status of the specified period.
ruboty /show sqs state last (?<time>\d+)(?<format>(w|d|h|m)) trend\z/ - Show all sqs queue status with trend of the last [w]eeks, [d]ays, [h]ours or [m]inutes.
ruboty /show sqs state last (?<time>\d+)(?<format>(w|d|h|m))\z/ - Show all sqs queue status of the last [w]eeks, [d]ays, [h]ours or [m]inutes.
```

### Example
```
$ bundle exec ruboty
Type `exit` or `quit` to end the session.
> @ruboty add sqs foo sqs-name-xxx
SQS foo registerd.
> @ruboty list sqs queues
foo: sqs-name-xxx
> @ruboty show sqs state 20160320 20160323
2016-03-20T00:00:00Z - 2016-03-23T00:00:00Z
*** foo(sqs-name-xxx) ***
  - ApproximateNumberOfMessagesDelayed(Maximum)   	0
  - ApproximateNumberOfMessagesNotVisible(Maximum)	1
  - ApproximateNumberOfMessagesVisible(Maximum)   	0
  - NumberOfEmptyReceives(Sum)                    	12929
  - NumberOfMessagesDeleted(Sum)                  	18
  - NumberOfMessagesReceived(Sum)                 	30
  - NumberOfMessagesSent(Sum)                     	19
  - SentMessageSize(Average)                      	813
> @ruboty show sqs state last 3d
2016-03-20T00:00:00Z - 2016-03-23T00:00:00Z
*** foo(sqs-name-xxx) ***
  - ApproximateNumberOfMessagesDelayed(Maximum)   	0
  - ApproximateNumberOfMessagesNotVisible(Maximum)	1
  - ApproximateNumberOfMessagesVisible(Maximum)   	0
  - NumberOfEmptyReceives(Sum)                    	12929
  - NumberOfMessagesDeleted(Sum)                  	18
  - NumberOfMessagesReceived(Sum)                 	30
  - NumberOfMessagesSent(Sum)                     	19
  - SentMessageSize(Average)                      	813
> @ruboty show sqs state last 3d trend
2016-03-20T00:00:00Z - 2016-03-23T00:00:00Z
*** foo(sqs-name-xxx) ***
  - ApproximateNumberOfMessagesDelayed(Maximum)   	0 0 0
  - ApproximateNumberOfMessagesNotVisible(Maximum)	0 1 0
  - ApproximateNumberOfMessagesVisible(Maximum)   	0 0 0
  - NumberOfEmptyReceives(Sum)                    	4288 4297 4344
  - NumberOfMessagesDeleted(Sum)                  	0 1 17
  - NumberOfMessagesReceived(Sum)                 	0 13 17
  - NumberOfMessagesSent(Sum)                     	0 2 17
  - SentMessageSize(Average)                      	0 529 846
> @ruboty delete sqs foo
SQS foo deleted
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ruboty-sqs_monitor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

