require_relative "base"

module Ruboty
  module SqsMonitor
    module Actions
      class Delete < Base
        def call
          message.reply(delete)
        rescue => e
          message.reply(e.message)
        end

        private
        def delete
          name = message[:name]
          if queues.has_key?(name)
            queues.delete(name)
            "SQS #{name} deleted"
          else
            "SQS #{name} does not exist"
          end
        end
      end
    end
  end
end
