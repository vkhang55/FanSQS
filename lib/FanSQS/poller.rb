module FanSQS
  class Poller
    # TODO: check for new queues created as well
    def self.guard
      loop do
        # AWS::SQS::Client.new.list_queues
        # AWS.sqs.queues.each do |queue|
        FanSQS::Worker.queue_names.unique.each do |name|
          queue = Queue.instantiate(name)
          messages = queue.receive_message(limit: 10)
          messages.each do |message|
            process(message)
          end
        end
      end
    end

    def self.process(msg)
      message = parse(msg)
      klass = Object::const_get(message['class'])
      fork do
        klass.perform(message['body'])
      end
    end

    private
    def self.parse(msg)
      json = JSON.parse(msg)
      return json
    rescue JSON::ParserError # malformed JSON
        return nil
    end
  end
end
