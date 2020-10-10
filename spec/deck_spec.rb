require "deck"

describe "Deck" do
  subject(:deck) {Deck.new}
  describe "#initialize" do
    it "creates and reads @cards" do
      expect(deck.cards).to be_truthy
    end

    it "creates and reads @discard as empty array" do
      expect(deck.discard).to be([])
    end

    it "calls #fill_deck" do
      expect(deck).to receive(:fill_deck)
    end

    it "calls #shuffle" do
      expect(deck).to receive(:shuffle)
    end
  end

  describe "#fill_deck" do
    it "calls Card.new" do
      expect(subject.fill_deck).to receive(:Card.new)
    end

    it "adds all cards for all four suits to @cards" do
      expect(subject.cards.length).to eq(52)
    end

    it "does not duplicate cards" do
      expect(subject.cards).to eq(suject.cards.uniq)
    end
  end

  describe "#shuffle" do
    it "shuffles @cards" do
      expect(deck).not_to eq(deck.shuffle)
    end
  end

  describe "#deal" do
    it "takes in a number of cards" do
      expect{deck.deal(5)}.not_to raise_error
    end

    it "returns given amount of cards from top of deck as array" do
      expect(deck.cards[-5..-1]).to eq(deck.deal(5))
    end

    it "removes dealt cards from deck" do
      deck.deal(5)
      expect(deck.cards.length).to eq(47)
    end
  end
end