module SQSReceivedMessageMocks
  def mocked_received_message(name = 'received_message')
    received_message = double(name)
    allow(received_message).to receive(:body).and_return(
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
