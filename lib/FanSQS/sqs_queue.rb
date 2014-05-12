module FanSQS
  class SQSQueue
    class << self
      def create_message(klass, msg_body)
        queue(klass.queue).send_message({ class: klass.name, body: msg_body }.to_json)
      end

      # Find out if the queue exists. If it does not exist, create a new one
      def queue(qname)
        exists?(qname) || AWS.sqs.create(qname)
      end

      def exists?(qname)
        AWS.sqs.named(qname)
      rescue AWS::SQS::Errors::NonExistentQueue
        return false
      end
    end
  end
end
