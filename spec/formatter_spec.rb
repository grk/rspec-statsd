require 'spec_helper'

describe RSpec::Statsd::Formatter do
  let(:formatter) { RSpec::Statsd::Formatter.new(nil) }
  let(:client) { mock(HttpStatsd::Client).as_null_object }

  before do
    formatter.stub(:client => client)
  end

  describe "dump_summary" do
    it "should measure duration" do
      client.should_receive(:gauge).with("sample-test.duration", 12.3)
      formatter.dump_summary(12.3, 10, 0, 0)
    end

    it "should count runs" do
      client.should_receive(:increment).with("sample-test.count")
      formatter.dump_summary(12.3, 10, 0, 0)
    end

    context "when suite is successful" do
      it "should measure successful duration" do
        client.should_receive(:gauge).with("sample-test.success.duration", 12.3)
        formatter.dump_summary(12.3, 10, 0, 0)
      end

      it "should count successful runs" do
        client.should_receive(:increment).with("sample-test.success.count")
        formatter.dump_summary(12.3, 10, 0, 0)
      end
    end

    context "when suite has failures" do
      it "should measure failed duration" do
        client.should_receive(:gauge).with("sample-test.failure.duration", 12.3)
        formatter.dump_summary(12.3, 9, 1, 0)
      end

      it "should count failed runs" do
        client.should_receive(:increment).with("sample-test.failure.count")
        formatter.dump_summary(12.3, 9, 1, 0)
      end
    end
  end

  context "when can't connect to statsd proxy" do
    it "should print the exception" do
      expect_output("RSpec::Statsd: Could not send gauge sample-test.duration:")
      expect_output("#<Exception: connection error>")
      expect_output("RSpec::Statsd: Could not send gauge sample-test.failure.duration:")
      expect_output("#<Exception: connection error>")
      client.stub(:gauge).and_raise(Exception.new("connection error"))
      formatter.dump_summary(12.3, 9, 1, 0)
    end

    def expect_output(output)
      STDOUT.should_receive(:puts).with(output)
    end
  end
end
