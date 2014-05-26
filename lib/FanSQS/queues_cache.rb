# QueuesCache's purpose is for speed optimization. Using this class, we do not have to constantly ping
# AWS for new queues. It will ping AWS only every X times.
module FanSQS
  class QueuesCache
    def initialize
      @counter = 0
      @sqs_client ||= AWS::SQS::Client.new
      @queues = []
    end

    def fetch
      if @counter % 20 == 0
        @counter = 0 # reset counter
        @queue_names = @sqs_client.list_queues[:queue_urls].map { |q| q.split('/').last }.uniq
        @queues = @queue_names.inject([]) { |queues, name| queues << Queue.instantiate(name) } # reset cache & fetch queues from AWS
      else
        @counter += 1
        @queues
      end
    end
  end
end
