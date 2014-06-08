module SQSQueueStubs
  # stubbed for 
  #     AWS.sqs.queues.create(name.to_s)
  def stub_queue_create
    allow_any_instance_of(AWS::SQS::QueueCollection).to receive(:create).with(an_instance_of(String)).and_return(mocked_queue)
  end

  # stubbed for 
  #     AWS::SQS.new.queues.named(qname)
  #     AWS.sqs.queues.named(formatted_queue_name(qname))
  def stub_retrieving_named_queues
    allow_any_instance_of(AWS::SQS::QueueCollection).to receive(:named).with(an_instance_of(String)).and_return(mocked_queue)
  end

  # stubbed for 
  #     AWS::SQS.new.queues.named(qname)
  def stub_retrieving_named_queues_raise_exception
    allow_any_instance_of(AWS::SQS::QueueCollection).to receive(:named).with(an_instance_of(String)).and_raise(AWS::SQS::Errors::NonExistentQueue)
  end

  # stubbed for 
  #     AWS::SQS.new.queues.with_prefix(qname.split('*').first)
  def stub_retrieving_queues_with_prefix
    allow_any_instance_of(AWS::SQS::QueueCollection).to receive(:with_refix).with(any_args).and_return(mocked_queue_collection)
  end

  # stubbed for 
  #     AWS::SQS::Client.new.list_queues[:queue_urls]
  def stub_client_list_queues
    queue_urls = { queue_urls: ["https://sqs.us-east-1.amazonaws.com/1/queue_1", "https://sqs.us-east-1.amazonaws.com/2/queue_2", "https://sqs.us-east-1.amazonaws.com/3/queue_3"] }
    allow_any_instance_of(AWS::SQS::Client::V20121105).to receive(:list_queues).and_return(queue_urls)
  end

  # stub for
  #     queue.receive_messages(limit: 10) do |message|
  def stub_queue_receive_messages(size = 10)
    received_messages = mocked_received_message_collection(size)
    allow_any_instance_of(AWS::SQS::Queue).to receive(:receive_messages).with(limit: size).and_yield(receive_messages)
  end

  # stub for
  #     params = { class: self.name, arguments: args }
  #     queue.send_message(params.to_json)
  def stub_queue_send_message(size = 10)
    allow_any_instance_of(AWS::SQS::Queue).to receive(:send_message).with(an_instance_of(Hash)).and_return(mocked_sent_message)
  end
end
