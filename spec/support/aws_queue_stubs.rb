module AWSQueueStubs
  def mocked_queue(name = 'queue')
    queue = double(name)
  end

  def mocked_queue_collection(size = 3)
    queues = []
    size.times do |i|
      queues << mocked_queue("queue_#{i}")
    end
  end

  # stubbed for AWS.sqs.queues.create(name.to_s)
  def stub_queue_create
    QueueCollection.any_instance.stub(:create).with(an_instance_of(String)).and_return(mocked_queue)
  end

  # stubbed for AWS::SQS.new.queues.named(qname)
  def stub_retrieving_named_queues
    QueueCollection.any_instance.stub(:named).with(an_instance_of(String)).and_return(mocked_queue)
  end

  # stubbed for AWS.sqs.queues.named(formatted_queue_name(qname))
  def stub_retrieving_named_queues_2
    stub_retrieving_named_queues
  end

  # stubbed for AWS::SQS.new.queues.with_prefix(qname.split('*').first)
  def stubs_retrieving_queues_with_prefix
    QueueCollection.any_instance.stub(:with_refix).with(an_instance_of(String)).and_return(mock_queue_collection)
  end

  def stubs_client_list_queues
    # AWS::SQS::Client.new.list_queues[:queue_urls]
  end

  def stub_queue_receive_messages
    # AWS::SQS.new.queues.named(qname)
    # queue.receive_messages(limit: 10) do |message|
  end
end
