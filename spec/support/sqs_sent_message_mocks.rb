module SQSSentMessageMocks
  def mocked_sent_message(name = 'sent_message')
    sent_message = double(name)
    sent_message.stub(:md5).and_return('md5_hash_value')
    sent_message
  end
end
