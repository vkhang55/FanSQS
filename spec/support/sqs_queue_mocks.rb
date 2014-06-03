module SQSQueueMocks
  def mocked_queue(name = 'queue')
    queue = double(name)
    received_messages = mocked_received_message_collection(10)
    queue.stub(:receive_messages).with({ limit: 10 }).and_return(received_messages)
  end

  def mocked_queue_collection(size = 3)
    queues = []
    size.times { |i| queues << mocked_queue("queue_#{i}") }
    queues
  end
end
