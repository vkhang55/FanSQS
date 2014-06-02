module FanSQS
  class QueueWrapper
    @@cache ||= {} # cache for queues

    class << self
      def create_message(klass, msg_body)
        instantiate(klass.queue).send_message({ class: klass.name, body: msg_body }.to_json)
      end

      # Find out if the queue exists. If it does not exist, create a new one
      # This line below has a high chance of causing confusion as it will try to use either FanSQS::Queue or AWS::SQS::Queue. Maybe use the class from AWS gem instead?
      def instantiate(qname)
        name = formatted_queue_name(qname)
        exists?(name) || create_new(name)
      end

      def create_new(name)
        binding.pry
        AWS.sqs.queues.create(name.to_s)
      end

      def cache
        @@cache
      end

      def exists?(qname)
        if @@cache[qname]
          return @@cache[qname]
        else
          return @@cache[qname] = AWS.sqs.queues.named(formatted_queue_name(qname)) while @@cache[qname] == nil
        end
      rescue AWS::SQS::Errors::NonExistentQueue
        return false
      end

      def formatted_queue_name(qname)
        qname.to_s
      end
    end
  end
end
