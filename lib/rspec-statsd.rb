require "rspec-statsd/version"
require "rspec-statsd/formatter"
require "http_statsd"

module RSpec
  module Statsd
    extend self

    attr_accessor :base_uri, :username, :password, :metric

    def client
      @client ||= HttpStatsd::Client.new(:base_uri => base_uri,
        :username => username, :password => password)
    end
  end
end
