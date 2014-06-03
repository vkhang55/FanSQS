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
    it "is a pending example"
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
