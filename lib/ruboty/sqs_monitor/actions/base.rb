module Ruboty
  module SqsMonitor
    module Actions
      class Base < Ruboty::Actions::Base
        private
        def queues
          message.robot.brain.data[Ruboty::SqsMonitor::NAMESPACE] ||= {}
        end
      end
    end
  end
end
