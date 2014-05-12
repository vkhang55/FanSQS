module FanSQS
  class Poller
    # TODO: check for new queues created as well
    def self.guard
      # infinite loop
      loop do
        # AWS::SQS::Client.new.list_queues
        AWS.sqs.queues.each do |queue|
          messages = queue.receive_message(limit: 10)
          messages.each do |message|
            # sqs.queues.first.poll do |msg|; puts "Incoming Message ====== '#{msg.body}'"; end
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

    def self.parse(msg)
      json = JSON.parse(msg)
      return json
    rescue JSON::ParserError # malformed JSON
        return nil
    end
  end
end
