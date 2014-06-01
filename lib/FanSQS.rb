require "FanSQS/pool"
require "FanSQS/version"
require "FanSQS/message_parser"
require "FanSQS/local_queue"
require "FanSQS/queues_cache"
require "FanSQS/poller"
require "FanSQS/worker"

# Reference: [http://ruby.awsblog.com/post/Tx16QY1CI5GVBFT/Threading-with-the-AWS-SDK-for-Ruby]
# Issue this line will give significant performance boost
AWS.eager_autoload!

# $pool = Pool.new(50) # Performs max at 50 threads. Need to make this value configurable later.

module FanSQS
  extend self

  ErrorQueue = :fan_sqs_queue_error
  class << self
    attr_accessor :pool
  end
  self.pool = Pool.new(100)
end
