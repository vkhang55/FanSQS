module FanSQS
  class Poller
    def self.guard
      loop do
        get_queues.uniq.each do |name|
          queue = Queue.instantiate(name)
          messages = queue.receive_message(limit: 10)
          messages.each do |message|
            process(message.body)
          end
        end
      end
    end

    def self.process(msg)
      message = parse(msg)
      klass = Object::const_get(message['class'])
      fork do
        klass.perform(message['message'])
      end
    end

    private
    def self.get_queues
      @sqs_client ||= AWS::SQS::Client.new
      @sqs_client.list_queues[:queue_urls].map { |q| q.split('/').last }
    end

    def self.parse(msg)
      json = JSON.parse(msg)
      return json
    rescue JSON::ParserError # malformed JSON
        return nil
    end
  end
end
