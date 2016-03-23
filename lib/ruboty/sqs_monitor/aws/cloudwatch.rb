module Ruboty
  module SqsMonitor
    module Aws
      class CloudWatch
        attr_reader :queue_name, :start_time, :end_time

        def initialize(queue_name, options)
          @queue_name = queue_name
          @start_time = options[:start_time]
          @end_time   = options[:end_time]

          opts = options.select {|k, v| CLIENT_OPTIONS.include? k.to_sym }
          @client = ::Aws::CloudWatch::Client.new(opts)
        end

        def get_statistics(metric_name,
                           stats:      nil,
                           start_time: nil,
                           end_time:   nil,
                           period:     nil)
          stats      ||= default_stats(metric_name)
          end_time   ||= @end_time   || Time.now
          start_time ||= @start_time || (end_time - 3600)
          period     ||= end_time - start_time

          opts = {
            namespace:   "AWS/SQS",
            metric_name: metric_name,
            dimensions:  [ {name: "QueueName", value: @queue_name} ],
            start_time:  start_time,
            end_time:    end_time,
            period:      period.to_i,
            statistics:  [stats]
          }
          resp = @client.get_metric_statistics(opts)

          datapoints = default_datapoints(start_time, end_time, period)
          resp.datapoints.each do |datapoint|
            ts = datapoint.timestamp
            dp = datapoints[ts.to_i]
            dp.value = datapoint_to_value(datapoint)
            dp.unit  = datapoint.unit
            dp.freeze
          end

          OpenStruct.new(
            queue_name: @queue_name,
            start_time: start_time,
            end_time:   end_time,
            metric:     resp.label,
            stats:      stats,
            label:      "#{resp.label}(#{stats})",
            datapoints: datapoints.sort_by{|k,v| k}.map(&:last)
          ).freeze
        end

        private
        CLIENT_OPTIONS = [:region, :access_key_id, :secret_access_key ]

        STATS_MAXIMUM_GROUP = %w{
          ApproximateNumberOfMessagesDelayed
          ApproximateNumberOfMessagesNotVisible
          ApproximateNumberOfMessagesVisible
        }

        STATS_AVERAGE_GROUP = %w{
          SentMessageSize
        }

        STATS_SUM_GROUP = %w{
          NumberOfEmptyReceives
          NumberOfMessagesDeleted
          NumberOfMessagesReceived
          NumberOfMessagesSent
        }

        def default_stats(metric)
          case metric
          when *STATS_MAXIMUM_GROUP
            "Maximum"
          when *STATS_AVERAGE_GROUP
            "Average"
          when *STATS_SUM_GROUP
            "Sum"
          else
            raise ArgumentError, "#{metric} is unknown metric name"
          end
        end

        def datapoint_to_value(dp)
          dp.sample_count || dp.average || dp.sum || dp.minimum || dp.maximum
        end

        def sec_truncate(t)
          Time.new(t.year, t.mon, t.day, t.hour, t.min, nil, t.utc_offset)
        end

        def default_datapoints(start_time, end_time, period)
          stime = sec_truncate(start_time)
          datapoints = {}
          ((end_time - start_time) / period).to_i.times do |i|
            ts = stime + i * period
            datapoints[ts.to_i] = OpenStruct.new(timestamp: ts, value: 0)
          end
          datapoints
        end
      end
    end
  end
end
