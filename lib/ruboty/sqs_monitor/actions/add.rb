require_relative "base"

module Ruboty
  module SqsMonitor
    module Actions
      class Add < Base
        def call
          message.reply(add)
        rescue => e
          message.reply(e.message)
        end

        private
        def add
          name = message[:name]
          real = message[:real_name]

          sqs = Ruboty::SqsMonitor.sqs(real)
          raise "SQS #{name} not found." unless sqs.exists?
          queues[name] = real

          "SQS #{name} registerd."
        end
      end
    end
  end
end
