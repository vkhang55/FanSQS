module FanSQS
  module Worker
    def self.included(base)
      base.extend(ClassMethods)
      base.class_attribute :fan_sqs_options
    end

    def self.perform_async(options = {})
      queue = Queue.instantiate(fan_sqs_options[:queue] || :default)
      queue.create_message(options.to_json)
    end

    def self.queue_names
      @queue_names
    end

    module ClassMethods
      attr_accessor :queue
      def enqueue(*msg_body)
        Queue.create_message(self, msg_body)
      end
    end
  end
end
