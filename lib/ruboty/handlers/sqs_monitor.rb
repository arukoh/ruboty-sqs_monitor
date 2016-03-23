require "ruboty/sqs_monitor/actions/add"
require "ruboty/sqs_monitor/actions/delete"
require "ruboty/sqs_monitor/actions/list"
require "ruboty/sqs_monitor/actions/state"
require "ruboty/sqs_monitor/actions/state_trend"

module Ruboty
  module Handlers
    # Monitor AWS SQS via Ruboty.
    class SqsMonitor < Base
      on /add sqs (?<name>.+) (?<real_name>.+)/, name: 'add', description: 'Add a new alias name of sqs queue to monitor.'
      on /delete sqs (?<name>.+)/, name: 'delete', description: 'Delete a alias name of sqs queue to monitor.'
      on /list sqs queues\z/, name: 'list', description: 'List all sqs queue names.'
      on /show sqs state last (?<time>\d+)(?<format>(w|d|h|m))\z/, name: 'state', description: 'Show all sqs queue status of the last [w]eeks, [d]ays, [h]ours or [m]inutes.'
      on /show sqs state last (?<time>\d+)(?<format>(w|d|h|m)) trend\z/, name: 'state_trend', description: 'Show all sqs queue status with trend of the last [w]eeks, [d]ays, [h]ours or [m]inutes.'
      on /show sqs state (?<from>(?:(?!last).)+) (?<to>.+)/, name: 'state', description: 'Show all sqs queue status of the specified period.'
      env :SQS_REGION, "AWS region for SQS.", optional: true
      env :SQS_ACCESS_KEY_ID, "AWS access key for SQS.", optional: true
      env :SQS_SECRET_ACCESS_KEY, "AWS secret key for SQS.", optional: true
      env :SQS_METRICS, "Metric list to ask.", optional: true
      env :SQS_TREND_SEPARATOR, "Trend separator.", optional: true

      def add(message)
        Ruboty::SqsMonitor::Actions::Add.new(message).call
      end

      def delete(message)
        Ruboty::SqsMonitor::Actions::Delete.new(message).call
      end

      def list(message)
        Ruboty::SqsMonitor::Actions::List.new(message).call
      end

      def state(message)
        Ruboty::SqsMonitor::Actions::State.new(message).call
      end

      def state_trend(message)
        Ruboty::SqsMonitor::Actions::StateTrend.new(message).call
      end
    end
  end
end
