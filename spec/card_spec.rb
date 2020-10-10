require 'card'

describe "Card" do
  subject(:card) {Card.new(2,:S)}
  describe "#initialize" do
    it "takes in a value(integer) and a suit(symbol)" do
      expect{Card.new(4,:H)}.not_to raise_error
    end
    it "sets and reads @value" do
      expect(card.value).to eq(2)
    end
    it "sets and reads @suit" do
      expect(card.suit).to eq(:S)
    end
  end
  
  describe "#symbol" do
    it "translates @suit and returns unicode symbol code" do
      expect(card.symbol).to eq("♠")
    end
  end

  describe "#to_s" do
    it "returns value and suit symbol as one string" do
      expect(card.to_s).to eq("2♠")
    end
  end
end