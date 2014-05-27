module FanSQS
  class MessageParser
    class << self
      def parse(msg)
        json = JSON.parse(msg, symbolize_names: true)
        return json
      rescue JSON::ParserError # malformed JSON
        return nil
      end
    end
  end
end
