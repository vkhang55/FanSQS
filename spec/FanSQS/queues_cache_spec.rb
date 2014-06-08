require 'spec_helper'

describe FanSQS::QueuesCache do
  describe "#initialize" do
    it "is a pending example"
  end

  describe "#fetch" do
    it "is a pending example"
  end

  describe "#fetch_all_queues" do
    it "is a pending example"
  end

  describe "#fetch_specific_queues" do
    it "should return 2 queues when counter % RESET_THRESHOLD is not 0" do
      @queues_cache = FanSQS::QueuesCache.new([:queue_1, :queue_2])
      sample_queues = [ mocked_queue('queue_1'), mocked_queue('queue_2') ]
      @queues_cache.instance_variable_set(:@queues, sample_queues)
      queues = @queues_cache.send(:fetch_all_queues)
      expect(queues.size).to eq(2)
      expect(queues).to eq(sample_queues)
    end

    it "should return 2 queues when counter % RESET_THRESHOLD is 0" do
      stubs_client_list_queues
      stub_retrieving_named_queues
      @queues_cache = FanSQS::QueuesCache.new([:queue_1, :queue_2, :queue_3])
      @queues_cache.instance_variable_set(:@cache, { :queue_1 => mocked_queue('queue_1'), :queue_2 => mocked_queue('queue_2'), :queue_3 => mocked_queue('queue_3')})
      @queues_cache.instance_variable_set(:@counter, FanSQS::QueuesCache::RESET_THRESHOLD)
      queues = @queues_cache.send(:fetch_all_queues)
      expect(queues.size).to eq(3)
    end
  end

  describe "#resolve_qnames" do
    let!(:qnames) { [ :q1, :q2 ] }
    let!(:obj) { FanSQS::QueuesCache.new(:sample) }

    it "should return the argument as it is passed in if the argument is an Array" do
      expect(obj.send(:resolve_qnames, qnames)).to eq(qnames)
    end

    it "should return the list of queues if it is passed in as a String" do
      expect(obj.send(:resolve_qnames, 'q1,q2,q3,q1').sort).to eq([ 'q1', 'q2', 'q3' ])
    end
  end
end
