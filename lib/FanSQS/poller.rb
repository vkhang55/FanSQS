require 'thread'

module FanSQS
  class Poller
    class << self
      def start(qnames = [])
        @queues_cache = FanSQS::QueuesCache.new(qnames)
        loop do
          @queues_cache.fetch.each do |queue|
            FanSQS.pool.schedule do # Allows for multiple concurrent (non-blocking) HTTP requests to SQS
              queue.receive_messages(limit: 10) do |message|
                process(message.body)
              end
            end
          end
        end
      end

      private

      def process(msg)
        message = MessageParser.parse(msg)
        Thread.new do
          begin
            klass = Object::const_get(message[:class])
            klass.send(:perform, *message[:arguments])
          rescue ArgumentError => e
            store_exception(e, message)
          end
        end
      end

      def store_exception(exception, message)
        error_message = { class: message[:class],
                          arguments: message[:arguments],
                          stack_trace: exception.backtrace.join("\n") }
        queue = FanSQS::QueueWrapper.instantiate(FanSQS::ErrorQueue)
        queue.send_message(error_message.to_json)
      end
    end
  end
end
