require 'rspec/core/formatters/base_formatter'

module RSpec
  module Statsd
    class Formatter < RSpec::Core::Formatters::BaseFormatter
      def dump_summary(duration, example_count, failure_count, pending_count)
        result = failure_count == 0 ? "success" : "failure"

        client.gauge("#{metric}.duration", duration)
        client.increment("#{metric}.count")
        client.gauge("#{metric}.#{result}.duration", duration)
        client.increment("#{metric}.#{result}.count")
      end

      private
      def client
        RSpec::Statsd.client
      end

      def metric
        RSpec::Statsd.metric
      end
    end
  end
end
