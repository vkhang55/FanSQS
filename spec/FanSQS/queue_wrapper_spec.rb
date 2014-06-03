require 'spec_helper'

describe FanSQS::QueueWrapper do
  before do
    stub_retrieving_named_queues
  end

  it "formats symbol to string qname" do
    FanSQS::QueueWrapper.send(:formatted_queue_name, :symbol).should be_an_instance_of(String)
  end
end
