require 'rubygems'
require 'bundler/setup'

require 'rspec-statsd'

RSpec.configure do |config|
  config.color_enabled = true
  config.before(:suite) do
    RSpec::Statsd.base_uri = "http://statsd.example.com"
    RSpec::Statsd.username = "api1"
    RSpec::Statsd.password = "pass1"
    RSpec::Statsd.metric = "sample-test"
  end
end
