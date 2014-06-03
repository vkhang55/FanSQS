require 'spec_helper'

describe FanSQS::QueueWrapper do
  before do
    stub_retrieving_named_queues
  end

  describe "#exists?" do
    context "cached" do
      it "should returns a named queue from @cache" do
        sample_queue = mocked_queue
        FanSQS::QueueWrapper.instance_variable_set(:@cache, {:sample_qname => sample_queue})
        expect(FanSQS::QueueWrapper.exists?(:sample_qname)).to eq(sample_queue)
      end
    end

    context "not cached" do
      before do
        FanSQS::QueueWrapper.instance_variable_set(:@cache, {}) #empty cache
      end

      it "should returns fetches the queue from AWS" do
        expect_any_instance_of(AWS::SQS::QueueCollection).to receive(:named)
        FanSQS::QueueWrapper.exists?(:sample_qname)
      end

      context "non-existent queue" do
        it "should raise exception AWS::SQS::Errors::NonExistentQueue and returns false" do
          stub_retrieving_named_queues_raise_exception
          FanSQS::QueueWrapper.exists?(:sample_qname).should eq(false)
        end
      end
    end
  end

  describe "#create_new" do
    it "should call #create method from QueueCollection" do
      expect_any_instance_of(AWS::SQS::QueueCollection).to receive(:create).once
      FanSQS::QueueWrapper.create_new(:sample_queue)
    end
  end

  describe "#instantiate" do
    context "cached" do
      it "should call exists?, receive a mocked queue, and not call create_new" do
        sample_queue = mocked_queue
        FanSQS::QueueWrapper.instance_variable_set(:@cache, {:sample_qname => sample_queue})
        expect(FanSQS::QueueWrapper).to_not receive(:create_new)
        FanSQS::QueueWrapper.instantiate(:sample_qname)
      end

      it "should call exists?, catch an exception, and call create_new" do
        stub_retrieving_named_queues_raise_exception
        FanSQS::QueueWrapper.instance_variable_set(:@cache, {})
        expect(FanSQS::QueueWrapper).to_not receive(:create_new).once
        FanSQS::QueueWrapper.instantiate(:sample_qname)
      end
    end
  end

  it "formats symbol to string qname" do
    expect(FanSQS::QueueWrapper.send(:formatted_queue_name, :symbol)).to be_an_instance_of(String)
  end
end
