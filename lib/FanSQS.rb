require "FanSQS/version"
require "FanSQS/poller"
require "FanSQS/sqs_queue"

module FanSQS
  extend self

  # Your code goes here...
  def enqueue(klass, msg_body={})
    SQSQueue.create_message(klass, msg_body)    
  end
end
