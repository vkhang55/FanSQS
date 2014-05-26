module FanSQS
  module Worker
    def self.included(base)
      base.extend(ClassMethods)
      base.class_attribute :fan_sqs_options_hash
    end

    module ClassMethods
      attr_accessor :queue

      def perform_async(*args)
        name = fan_sqs_options_hash ? fan_sqs_options_hash[:queue] : :fan_sqs_queue
        queue = FanSQS::Queue.instantiate(name)
        params = { class: self.name, message: args }
        queue.send_message(params.to_json)
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
