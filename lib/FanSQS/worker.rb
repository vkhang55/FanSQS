module FanSQS
  module Worker
    def self.included(base)
      base.extend(ClassMethods)
      base.class_attribute :fan_sqs_options
    end

    module ClassMethods
      attr_accessor :queue

      def perform_async(options = {})
        name = fan_sqs_options ? fan_sqs_options[:queue] : :default
        queue = FanSQS::Queue.instantiate(name)
        queue.send_message(options.to_json)
      end

      def enqueue(*msg_body)
        Queue.send_message(self, msg_body)
      end
    end
  end
end
