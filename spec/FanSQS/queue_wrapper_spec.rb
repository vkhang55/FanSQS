require 'spec_helper'

describe FanSQS::QueueWrapper do
  before do
    stub_retrieving_named_queues
  end

  describe "#exists?" do
    context "cached" do
      it "returns a named queue from @cache" do
        sample_queue = mocked_queue
        FanSQS::QueueWrapper.instance_variable_set(:@cache, {:sample_qname => sample_queue})
        expect(FanSQS::QueueWrapper.exists?(:sample_qname)).to eq(sample_queue)
      end
    end

    context "not cached" do
      it "returns fetches the queue from AWS"
    end

    context "non-existent queue" do
      it "raises error AWS::SQS::Errors::NonExistentQueue and returns false"
    end
  end

  it "formats symbol to string qname" do
    expect(FanSQS::QueueWrapper.send(:formatted_queue_name, :symbol)).to be_an_instance_of(String)
  end
end
