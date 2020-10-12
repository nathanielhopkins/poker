require "deck"

describe "Deck" do
  subject(:deck) {Deck.new}

  it "creates class constant SUITS equal to [:H,:D,:S,:C]" do
    expect(Deck::SUITS).to eq([:H,:D,:S,:C])
  end

  it 'creates class constant VALUES equal to ["2","3","4","5","6","7","8","9","10","J","Q","K","A"]' do
    expect(Deck::VALUES).to eq(["2","3","4","5","6","7","8","9","10","J","Q","K","A"])
  end

  describe "#initialize" do
    it "creates and reads @cards" do
      expect{deck.cards}.not_to raise_error
    end

    it "creates and reads @discard as empty array" do
      expect(deck.discard).to be_empty
    end
  end

  describe "#fill_deck" do

    it "returns an array" do
      expect(deck.fill_deck).to be_an(Array)
    end

    it "output is taken in by @cards" do
      expect(deck.fill_deck).to match_array(deck.cards)
    end

    it "adds all cards for all four suits to @cards" do
      expect(deck.fill_deck.length).to eq(52)
    end

    it "does not duplicate cards" do
      expect(deck.shuffle).to eq(deck.shuffle.uniq)
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