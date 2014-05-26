module FanSQS
  module Worker
    def self.included(base)
      base.extend(ClassMethods)
      base.class_attribute :fan_sqs_options_hash
    end

    module ClassMethods
      attr_accessor :queue

      def perform_async(options = {})
        name = fan_sqs_options_hash ? fan_sqs_options_hash[:queue] : :default
        queue = FanSQS::Queue.instantiate(name)
        options.merge!(class: self.class.name)
        queue.send_message(options.to_json)
      end

      def set_fan_sqs_options(options = {})
        if options.empty?
          self.fan_sqs_options_hash = { queue: :default }
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
