module FanSQS
  class Poller
    def self.start
      @queues_cache = FanSQS::QueuesCache.new
      loop do
        @queues_cache.fetch.each do |queue|
          queue.receive_messages(limit: 10) do |message|
            process(message.body)
          end
        end
      end
    end

    def self.process(msg)
      message = parse(msg)
      klass = Object::const_get(message[:class])
      fork do
        klass.send(:perform, *message[:message])
      end
    end

    private
    def self.parse(msg)
      json = JSON.parse(msg, symbolize_names: true)
      return json
    rescue JSON::ParserError # malformed JSON
      return nil
    end
  end
end
