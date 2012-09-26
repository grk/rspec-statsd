require 'spec_helper'

describe RSpec::Statsd do
  describe "client" do
    it "should return a HttpStatsd::Client" do
      client = mock
      HttpStatsd::Client.should_receive(:new).with(:username => "api1",
        :password => "pass1", :base_uri => "http://statsd.example.com").
        and_return(client)

      RSpec::Statsd.client.should eql(client)
    end
  end
end
