require_relative "base"

module Ruboty
  module SqsMonitor
    module Actions
      class List < Base
        def call
          message.reply(list)
        rescue => e
          message.reply(e.message)
        end

        private
        def list
          if queues.empty?
            "SQS not found"
          else
            queues.map{|k, v| "#{k}: #{v}"}.join("\n")
          end
        end
      end
    end
  end
end
