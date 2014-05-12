module FanSQS
  class Queue
    class << self
      def create_message(klass, msg_body)
        instantiate(klass.queue).send_message({ class: klass.name, body: msg_body }.to_json)
      end

      # Find out if the queue exists. If it does not exist, create a new one
      def instantiate(qname)
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
