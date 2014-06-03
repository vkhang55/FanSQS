module SQSReceivedMessageMocks
  def mocked_received_message(name = 'received_message')
    received_message = double(name)
    received_message.stub(:body).and_return(
      {
        class: 'MessagePublisher',
        arguments: [ name ]
      }.to_json
    )
  end

  def mocked_received_message_collection(size = 3)
    received_messages = []
    size.times { |i| received_messages << mocked_received_message("received_message_#{i}") }
    received_messages
  end
end
