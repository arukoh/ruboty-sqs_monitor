module Ruboty
  module SqsMonitor
    module Aws
      class Sqs
        def initialize(name, options)
          @name = name

          opts = options.select {|k, v| CLIENT_OPTIONS.include? k.to_sym }
          @client = ::Aws::SQS::Client.new(opts)
        end

        def exists?
          result = @client.list_queues(queue_name_prefix: @name)
          !!result.queue_urls.find {|url| url.to_s.end_with? @name }
        rescue
          false
        end

        private
        CLIENT_OPTIONS = [:region, :access_key_id, :secret_access_key ]
      end
    end
  end
end
