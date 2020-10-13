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

    it "returns face cards(value>10) with letter value (11='J')" do
      expect(Card.new(11,:H).to_s).to eq("J♥")
      expect(Card.new(12,:D).to_s).to eq("Q♦")
      expect(Card.new(13,:C).to_s).to eq("K♣")
      expect(Card.new(14,:S).to_s).to eq("A♠")
    end
  end
end