require 'thread'

module FanSQS
  module Worker
    def self.included(base)
      base.extend(ClassMethods)
      base.class_attribute :fan_sqs_options_hash
    end

    module ClassMethods
      def perform_async(*args)
        # Allows for multiple concurrent (non-blocking) HTTP requests to SQS
        Thread.new do
          qname = fan_sqs_options_hash ? fan_sqs_options_hash[:queue] : :fan_sqs_queue
          queue = FanSQS::Queue.instantiate(qname)
          params = { class: self.name, arguments: args }
          queue.send_message(params.to_json)
        end
      end

      def set_fan_sqs_options(options = {})
        if options.empty?
          self.fan_sqs_options_hash = { queue: :fan_sqs_queue }
        else
          self.fan_sqs_options_hash = options
        end
      end

      def enqueue(*msg_body)
        Queue.send_message(self, msg_body)
      end
    end
  end
end
