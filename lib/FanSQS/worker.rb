module FanSQS
  module Worker
    def self.included(base)
      base.extend(ClassMethods)
      @queue_names ||= []
      @queue_names << base.queue || 'default' # add a queue or default it
    end

    module ClassMethods
      def enqueue(*msg_body)
        Queue.create_message(self, msg_body)
      end
    end
  end
end
