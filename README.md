# RSpec::Statsd

[![Build Status](https://secure.travis-ci.org/grk/rspec-statsd.png)](http://travis-ci.org/grk/rspec-statsd)


RSpec::Statsd provides a way to measure rspec runs in statsd. It uses the
[http_statsd](https://github.com/grk/http_statsd/) gem to send the results
over HTTP to a http statsd proxy.

## Usage

Add the gem to your Gemfile, and add the following lines to your spec_helper.rb:

```ruby
RSpec::Statsd.base_uri = "http://statsd.example.com"
RSpec::Statsd.username = "api1"
RSpec::Statsd.password = "pass1"
RSpec::Statsd.metric = "some-test"

RSpec.configure do |config|
  config.add_formatter("progress")
  config.add_formatter(RSpec::Statsd::Formatter)
end
```

The Formatter will send the following metrics to statsd when a suite is ran:

  * `some-test.duration` - timing with the duration of the rspec run
  * `some-test.count` - counter will be incremented

Additionally, when the suite has no errors:

  * `some-test.success.duration` - timing with the duration of the rspec run
  * `some-test.success.count` - counter will be incremented

And when the suite has errors:

  * `some-test.failure.duration` - timing with the duration of the rspec run
  * `some-test.failute.count` - counter will be incremented
