require "ruboty/sqs_monitor/version"
require "ruboty/sqs_monitor/aws"
require "ruboty/handlers/sqs_monitor"

module Ruboty
  module SqsMonitor
    NAMESPACE = "sqs_monitor"

    class << self
      def sqs(name)
        Aws::Sqs.new(name, sdk_options)
      end

      def cloudwatch(sqs_name, start_time=nil, end_time=nil)
        options = sdk_options.merge(
          start_time: start_time,
          end_time:   end_time,
        )
        Aws::CloudWatch.new(sqs_name, options)
      end

      def metrics
        (ENV["SQS_METRICS"] || DEFAULT_METRICS).split(/,/)
      end

      def trend_separator
        ENV["SQS_TREND_SEPARATOR"] || " "
      end

      private
      DEFAULT_METRICS = %w{
        ApproximateNumberOfMessagesDelayed
        ApproximateNumberOfMessagesNotVisible
        ApproximateNumberOfMessagesVisible
        NumberOfEmptyReceives
        NumberOfMessagesDeleted
        NumberOfMessagesReceived
        NumberOfMessagesSent
        SentMessageSize
      }.join(",")

      def sdk_options
        options = {
          http_proxy: ENV["HTTPS_PROXY"] || ENV["https_proxy"] || ENV["HTTP_PROXY"] || ENV["http_proxy"]
        }
        options[:region]            = ENV["SQS_REGION"]            if ENV["SQS_REGION"]
        options[:access_key_id]     = ENV["SQS_ACCESS_KEY_ID"]     if ENV["SQS_ACCESS_KEY_ID"]
        options[:secret_access_key] = ENV["SQS_SECRET_ACCESS_KEY"] if ENV["SQS_SECRET_ACCESS_KEY"]
        options
      end
    end
  end
end
