require 'spec_helper'

describe FanSQS::MessageParser do
  describe "#parse" do
    it "should return a JSON object with expected result" do
      msg = { a: 1, b: 2}
      json = FanSQS::MessageParser.parse(msg.to_json)
      expect(json).to eq(msg)
    end
  end
end
