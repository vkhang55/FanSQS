require "FanSQS/version"
require "FanSQS/queue"
require "FanSQS/queues_cache"
require "FanSQS/poller"
require "FanSQS/worker"

module FanSQS
  extend self

  # Your code goes here...
  # def enqueue(klass, msg_body={})
  #   SQSQueue.create_message(klass, msg_body)    
  # end
end
