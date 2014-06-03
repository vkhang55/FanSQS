module SQSQueueStubs
  # stubbed for 
  #     AWS.sqs.queues.create(name.to_s)
  def stub_queue_create
    AWS::SQS::QueueCollection.any_instance.stub(:create).with(an_instance_of(String)).and_return(mocked_queue)
  end

  # stubbed for 
  #     AWS::SQS.new.queues.named(qname)
  def stub_retrieving_named_queues
    AWS::SQS::QueueCollection.any_instance.stub(:named).with(an_instance_of(String)).and_return(mocked_queue)
  end

  # stubbed for 
  #     AWS.sqs.queues.named(formatted_queue_name(qname))
  def stub_retrieving_named_queues_2
    stub_retrieving_named_queues
  end

  # stubbed for 
  #     AWS::SQS.new.queues.with_prefix(qname.split('*').first)
  def stubs_retrieving_queues_with_prefix
    AWS::SQS::QueueCollection.any_instance.stub(:with_refix).with(an_instance_of(String)).and_return(mock_queue_collection)
  end

  # stubbed for 
  #     AWS::SQS::Client.new.list_queues[:queue_urls]
  def stubs_client_list_queues
    queue_urls = ["https://sqs.us-east-1.amazonaws.com/1/queue1", "https://sqs.us-east-1.amazonaws.com/2/queue2", "https://sqs.us-east-1.amazonaws.com/3/queue3"] 
    AWS::SQS::Client.any_instance.stub(:list_queues[]).with(an_instance_of(Symbol)).and_return(queue_urls)
  end

  # stub for
  #     queue.receive_messages(limit: 10) do |message|
  def stub_queue_receive_messages(size = 10)
    received_messages = mocked_received_message_collection(size)
    AWS::SQS::Queue.any_instance.stub(:receive_messages).with(limit: size).and_yield(receive_messages)
  end

  # stub for
  #     params = { class: self.name, arguments: args }
  #     queue.send_message(params.to_json)
  def stub_queue_send_message(size = 10)
    AWS::SQS::Queue.any_instance.stub(:send_message).with(an_instance_of(Hash)).and_return(mocked_sent_message)
  end
end
