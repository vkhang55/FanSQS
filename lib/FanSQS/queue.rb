module FanSQS
  class Queue
    class << self
      def create_message(klass, msg_body)
        instantiate(klass.queue).send_message({ class: klass.name, body: msg_body }.to_json)
      end

      # Find out if the queue exists. If it does not exist, create a new one
      def instantiate(qname)
        name = formatted_queue_name(qname)
        # this line below will cause confusion as it will try to use either FanSQS::Queue or AWS::SQS::Queue.
        # Maybe use the class from AWS gem instead?
        exists?(name) || AWS.sqs.queues.create(name)
      end

      def exists?(qname)
        AWS.sqs.queues.named(formatted_queue_name(qname))
      rescue AWS::SQS::Errors::NonExistentQueue
        return false
      end

      def formatted_queue_name(qname)
        qname.to_s
      end
    end
  end
end
