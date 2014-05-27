# QueuesCache's purpose is for speed optimization. Using this class, we do not have to constantly ping
# AWS for new queues. It will ping AWS only every X times.
module FanSQS
  class QueuesCache
    def initialize(qnames)
      @sqs_client ||= AWS::SQS::Client.new
      @qnames = resolve_qnames(qnames)
      @counter = 1
      @queues = []
    end

    def fetch
      if @qnames.empty?
        fetch_all_queues
      else
        fetch_specific_queues
      end
    end

    private
    # Fetch all queues except for the queue equals to FanSQS::ErrorQueue
    def fetch_all_queues
      if @counter % 20 == 0
        @counter = 1 # reset counter
        @queue_names = @sqs_client.list_queues[:queue_urls].map { |q| q.split('/').last }.uniq
        @queue_names.reject! { |name| name == FanSQS::ErrorQueue.to_s } # do not include the error queue
        @queues = @queue_names.inject([]) { |queues, name| queues << Queue.instantiate(name) } # reset cache & fetch queues from AWS
      else
        @counter += 1
        @queues
      end
    end

    # Fetch only specific queues. Can also fetch queues with prefix = "xxx*"
    def fetch_specific_queues
      return @queues unless @queues.empty?  
      @qnames.each do |qname|
        if qname =~ /\*/
          queues_with_prefix = AWS::SQS.new.queues.with_prefix(qname.split('*').first)
          queues_with_prefix.each do |queue|
            @queues << queue
          end
        else
          @queues << AWS::SQS.new.queues.named(qname)
        end
      end
    end

    def resolve_qnames(qnames)
      if qnames.is_a?(Array)
        qnames
      else
        qnames.split(',').uniq
      end
    end
  end
end
