require 'spec_helper'

describe FanSQS::QueuesCache do
  describe "#initialize" do
    it "should call these methods and end up with these values" do
      qnames = [ :queue_1, :queue_2 ]
      @queues_cache = FanSQS::QueuesCache.new(qnames)
      expect(@queues_cache.instance_variable_get(:@qnames)).to eq(qnames.map(&:to_s))
      expect(@queues_cache.instance_variable_get(:@counter)).to eq(1)
      expect(@queues_cache.instance_variable_get(:@queues)).to eq([])
    end
  end

  describe "#fetch" do
    context "@qnames.empty" do
      it "should call fetch_all_queues" do
        qnames = []
        @queues_cache = FanSQS::QueuesCache.new(qnames)
        expect(@queues_cache).to receive(:fetch_all_queues).once
        @queues_cache.fetch
      end
    end

    context "@qnames is not empty" do
      it "should call fetch_specific_queues" do
        qnames = [:queue_1, :queue_2]
        @queues_cache = FanSQS::QueuesCache.new(qnames)
        expect(@queues_cache).to receive(:fetch_specific_queues).once
        @queues_cache.fetch
      end
    end
  end

  describe "#fetch_all_queues" do
    context "counter % RESET_THRESHOLD != 0" do
      before do
        @queues_cache = FanSQS::QueuesCache.new([:queue_1, :queue_2])
        @sample_queues = [ mocked_queue('queue_1'), mocked_queue('queue_2') ]
        @queues_cache.instance_variable_set(:@queues, @sample_queues)
      end

      it "should return 2 queues" do
        queues = @queues_cache.send(:fetch_all_queues)
        expect(queues.size).to eq(2)
        expect(queues).to eq(@sample_queues)
      end
    end

    context "counter % RESET_THRESHOLD == 0" do
      before do
        stub_client_list_queues
        stub_retrieving_named_queues
        @queues_cache = FanSQS::QueuesCache.new([:queue_1, :queue_2, :queue_3])
        @queues_cache.instance_variable_set(:@cache, { :queue_1 => mocked_queue('queue_1'), :queue_2 => mocked_queue('queue_2'), :queue_3 => mocked_queue('queue_3')})
        @queues_cache.instance_variable_set(:@counter, FanSQS::QueuesCache::RESET_THRESHOLD)
      end

      it "should return 3 queues" do
        queues = @queues_cache.send(:fetch_all_queues)
        expect(queues.size).to eq(3)
      end
    end
  end

  describe "#fetch_specific_queues" do
    context "@queues is not empty" do
      before do
        @queues_cache = FanSQS::QueuesCache.new([:queue_1, :queue_2, :queue_3])
        @queues_cache.instance_variable_set(:@queues, [ mocked_queue('queue_1') ])
      end

      it "should return @queues" do
        queues = @queues_cache.send(:fetch_specific_queues)
        expect(queues.size).to eq(1)
      end
    end

    context "@queues is empty" do
      before do
        stub_retrieving_named_queues
        @queues_cache = FanSQS::QueuesCache.new([:queue_1, :queue_2])
        @queues_cache.instance_variable_set(:@queues, [ ])
      end

      it "should return 2 queues" do
        queues = @queues_cache.send(:fetch_specific_queues)
        expect(queues.size).to eq(2)
      end
    end
  end

  describe "#resolve_qnames" do
    let!(:qnames) { [ :q1, :q2 ] }
    let!(:obj) { FanSQS::QueuesCache.new(:sample) }

    it "should return the argument as it is passed in if the argument is an Array" do
      expect(obj.send(:resolve_qnames, qnames)).to eq(qnames.map(&:to_s))
    end

    it "should return the list of queues if it is passed in as a String" do
      expect(obj.send(:resolve_qnames, 'q1,q2,q3,q1').sort).to eq([ 'q1', 'q2', 'q3' ])
    end
  end
end
