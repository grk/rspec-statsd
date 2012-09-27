require 'rspec/core/formatters/base_formatter'

module RSpec
  module Statsd
    class Formatter < RSpec::Core::Formatters::BaseFormatter
      def dump_summary(duration, example_count, failure_count, pending_count)
        result = failure_count == 0 ? "success" : "failure"

        measure(:gauge, "#{metric}.duration", duration)
        measure(:increment, "#{metric}.count")
        measure(:gauge, "#{metric}.#{result}.duration", duration)
        measure(:increment, "#{metric}.#{result}.count")
      end

      private
      def measure(*args)
        type = args.shift
        client.send(type, *args)
      rescue Exception => ex
        puts "RSpec::Statsd: Could not send #{type} #{args.first}:"
        puts ex.inspect
      end

      def client
        RSpec::Statsd.client
      end

      def metric
        RSpec::Statsd.metric
      end
    end
  end
end
