require "player"

describe "Player" do
  let(:card1) {Card.new(2,:H)}
  let(:card2) {Card.new(2,:S)}
  let(:card3) {Card.new(5,:H)}
  let(:card4) {Card.new(13,:C)}
  let(:card5) {Card.new(7,:D)}
  let(:card6) {Card.new(14,:S)}
  let(:card7) {Card.new(3,:H)}
  let(:test_hand) { Hand.new(card1,card2,card3,card4,card5)}
  let(:new_hand) {Hand.new(card3,card4,card5,card6,card7)}
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

  describe "pot=(value)" do
    it "allows @pot to eq new value" do
      player.pot = ('test')
      expect(player.pot).to eq('test')
    end
  end

  describe "new_hand(value)" do
    
    it "allows @hand to eq new value" do 
      player.new_hand(new_hand)
      expect(player.hand).to eq(new_hand)
    end 

    it "updates @cards to new hand" do
      player.new_hand(new_hand)
      expect(player.cards).to eq([card3,card4,card5,card6,card7])
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
  end
  
  describe "#discard_display" do
    it "helper method that prints each card.to_s, provides user prompt" do
      allow_any_instance_of(Player).to receive(:discard_display).and_return(nil)
      expect{player.discard_display}.not_to raise_error
    end
  end

  describe "#discard_input" do

    it "helper method that gets user input for discard and returns as an array" do
      allow_any_instance_of(Player).to receive(:gets).and_return('1,2')
      expect(player.discard_input).to be_an(Array)
    end
    
    context "up to three cards are entered" do
      it  "returns cards matching input from discard_display" do
        allow_any_instance_of(Player).to receive(:gets).and_return('1,2')
        expect(player.discard_input).to eq([card1,card2])
      end
    end

    context "more than three numbers or invalid input are entered" do
      it "rescues and retries" do
        allow_any_instance_of(Player).to receive(:gets).and_return('1,2,3,4','aljfa','1,2')
        expect(player.discard_input).to eq([card1,card2])
      end
    end

    context "'none' is entered" do
      it "returns ['none']" do
        allow_any_instance_of(Player).to receive(:gets).and_return('none')
        expect(player.discard_input).to eq('none')
      end
    end
  end

  describe "#discard_phase" do

    context "discard_input returns an array of cards" do
      it "calls #discard to remove cards from @cards" do
        allow_any_instance_of(Player).to receive(:discard_input).and_return([card1,card2])
        allow_any_instance_of(Player).to receive(:discard_display).and_return(nil)
        player.discard_phase
        expect(player.cards).to eq([card3,card4,card5])
      end

      it "returns array of discarded cards" do
        allow_any_instance_of(Player).to receive(:discard_input).and_return([card1,card2])
        allow_any_instance_of(Player).to receive(:discard_display).and_return(nil)
        expect(player.discard_phase).to eq([card1,card2])
      end
    end

    context "discard_input returns 'none'" do
      it "returns false" do
        allow_any_instance_of(Player).to receive(:discard_input).and_return('none')
        allow_any_instance_of(Player).to receive(:discard_display).and_return(nil)
        expect(player.discard_phase).to eq(false)
      end

      it "does not change @cards" do
        allow_any_instance_of(Player).to receive(:gets).and_return('none')
        allow_any_instance_of(Player).to receive(:discard_display).and_return(nil)
        player.discard_input
        expect(player.cards).to eq([card1,card2,card3,card4,card5])
      end
    end
  end

  describe "#get_action" do
    it "gets user input and returns :fold, :see, or :raise" do
      allow_any_instance_of(Player).to receive(:gets).and_return("fold")
      expect(player.get_action).to eq(:fold)
    end

    it "raises error, rescues, and retries if user input is not 'fold','see',or'raise'" do
      allow_any_instance_of(Player).to receive(:gets).and_return('bluff','beg','see')
      expect(player.get_action).to eq(:see)
    end
  end
end