require "FanSQS/version"
require "FanSQS/message_parser"
require "FanSQS/queue"
require "FanSQS/queues_cache"
require "FanSQS/poller"
require "FanSQS/worker"

module FanSQS
  extend self

  ErrorQueue = :fan_sqs_queue_error
end
