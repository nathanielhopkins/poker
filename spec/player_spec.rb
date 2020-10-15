require "player"

describe "Player" do
  let(:card1) {Card.new(2,:H)}
  let(:card2) {Card.new(2,:S)}
  let(:card3) {Card.new(5,:H)}
  let(:card4) {Card.new(13,:C)}
  let(:card5) {Card.new(7,:D)}
  let(:test_hand) { Hand.new(card1,card2,card3,card4,card5)}
  subject(:player) {Player.new(test_hand,100)}

  describe "#initialize" do

    it "takes in a hand and a pot" do
      expect{player}.not_to raise_error
    end

    it "sets and reads @hand as received hand" do
      expect(player.hand).to eq(test_hand)
    end

    it "sets and reads @cards as @hands.cards" do
      expect(player.cards).to eq([card1,card2,card3,card4,card5])
    end

    it "sets and reads @pot as received pot" do
      expect(player.pot).to eq(100)
    end
  end

  describe "cards=(value)" do
    it "allows @cards to eq new value" do
      player.cards=("test")
      expect(player.cards).to eq("test")
    end
  end

  describe "hand=(value)" do
    it "allows @hand to eq new value" do
      player.hand=('test')
      expect(player.hand).to eq('test')
    end 

    it "updates @cards to new hand" do
      player.hand=(new_hand)
      allow(:new_hand).to receive(:cards).and_return("new_cards")
      expect(player.cards).to eq("new_cards")
    end
  end

  describe "#discard" do
    it "takes in an array of cards as arg" do
      expect{player.discard([card1])}.not_to raise_error
      expect{player.discard([card1,card2,card3])}.not_to raise_error
    end

    it "removes inputed cards from @cards" do
      player.discard([card1,card2])
      expect(player.cards).to eq([card3,card4,card5])
    end

    it "returns removed cards as array" do
      expect(player.discard([card1,card2])).to eq([card1,card2])
    end
  end

  describe "#discard_prompt" do

    it "calls #discard to remove cards from player cards" do
      allow(:discard_prompt).to receive(:gets).and_return("card1,card2")
      expect(player.cards).to eq([card2,card3,card4,card5])
    end

    it "returns an array" do
      allow(:discard_prompt).to receive(:gets).and_return("card1,card2")
      expect(player.discard_prompt).to be_an(Array)
    end

    it "returns discarded cards" do
      allow(:discard_prompt).to receive(:gets).and_return("card1,card2")
      expect(player.discard_prompt).to eq([card1,card2])
    end
  end

  describe "#get_action" do
    it "returns :fold, :see, or :raise" do
      allow(:get_action).to receive(:gets).and_return("fold")
      expect(player.get_action).to be(:fold).or be(:see).or be(:raise)
    end

    it "raises error, rescues, and retries if user input is not 'folds','see',or'raise'" do
      allow(:get_action).to receive(:gets).and_return("bluff","raise")
      expect{player.get_action}.not_to raise_error
    end
  end
end