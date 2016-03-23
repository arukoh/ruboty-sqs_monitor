require_relative "base"

module Ruboty
  module SqsMonitor
    module Actions
      class State < Base
        def call
          message.reply(state)
        rescue => e
          message.reply(e.message)
        end

        private
        def state(trend=false)
          return "SQS not found" if queues.empty?

          start_time, end_time, period = get_time(trend)

          msg = []
          msg << "#{start_time.iso8601} - #{end_time.iso8601}"
          queues.each do |name, real|
            msg << "*** #{name}(#{real}) ***"

            resp = get_state(real, start_time, end_time, period)
            label_max = resp.map(&:label).map(&:size).max
            resp.each do |st|
              value = get_value(st)
              msg << "  - #{st.label.ljust(label_max)}\t#{value}"
            end
          end
          msg.join("\n")
        end

        def get_state(name, start_time, end_time, period)
          cloudwatch = Ruboty::SqsMonitor.cloudwatch(name, start_time, end_time)
          Ruboty::SqsMonitor.metrics.map do |metric|
            cloudwatch.get_statistics(metric, period: period)
          end
        end

        def get_time(trend)
          from   = message[:from]      rescue nil
          to     = message[:to]        rescue nil
          time   = message[:time].to_i rescue nil
          format = message[:format]    rescue nil
          if from && to
            last = Time.parse(from)
            now  = Time.parse(to)
            [ last, now, now - last ]
          else
            now = Time.now
            last = case format.to_s
                   when "w"
                     now - (time * 7 * 24 * 60 * 60)
                   when "d"
                     now - (time * 24 * 60 * 60)
                   when "h"
                     now - (time * 60 * 60)
                   when "m"
                     now - (time * 60)
                   else
                     now
                   end
            period = trend ? (now - last) / time : (now - last)
            [ last, now, period.to_i ]
          end
        end

        def get_value(st)
          values = []
          st.datapoints.each do |dp|
            values << (dp.unit.to_s.downcase == "seconds" ? "%0.2f"%dp.value : "%d"%dp.value)
          end
          values.empty? ? 0 : values.join(Ruboty::SqsMonitor.trend_separator)
        end
      end
    end
  end
end
