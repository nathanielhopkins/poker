require "hand"

describe "Hand" do
  let(:card1) {Card.new(2,:H)}
  let(:card2) {Card.new(2,:S)}
  let(:card3) {Card.new(5,:H)}
  let(:card4) {Card.new(13,:C)}
  let(:card5) {Card.new(7,:D)}
  let(:card6) {Card.new(14,:S)}
  let(:card7) {Card.new(3,:H)}
  let(:card8) {Card.new(4,:H)}
  let(:card9) {Card.new(6,:H)}
  subject(:hand) { Hand.new(card1,card2,card3,card4,card5)}

  it "creates Hand::HAND_SCORES as hash of scores (e.g. straight_flush:1)" do
    HAND_SCORES = { 
      straight_flush:1, 
      four_of_a_kind:2, 
      full_house:3, 
      flush:4,
      straight:5,
      three_of_a_kind:6,
      two_pair:7,
      pair:8,
      high_card:9
    }
    expect(Deck::HAND_SCORES).to match_hash(HAND_SCORES)
  end

  describe "#initialize" do
    it "takes in array of cards" do
      expect{hand}.not_to raise_error
    end
    it "sets and reads @cards to array taken in as arg" do
      expect(hand.cards).to eq([card1,card2,card3,card4,card5])
    end
  end

  describe "pair?" do
    it "returns a boolean" do
      expect(hand.pair?).to eq(true).or(false)
    end
    context "a pair is present" do
      it "returns true" do
        expect(hand.pair?).to eq(true)
      end
    end
    context "no pair is present" do
      let(:no_pair_hand) { Hand.new(card2,card3,card4,card5,card6)}
      it "returns false" do
        expect(no_pair_hand.pair?).to eq(false)
      end
    end
  end

  describe "straight?" do
      it "returns a boolean" do
        expect(hand.straight?).to eq(true).or(false)
      end
    context "a straight is present" do
      let(:straight_hand) {Hand.new(card1,card3,card7,card8,card9)}
      it "returns true" do
        expect(straight_hand.straight?).to eq(true)
      end
    end
    context "straight is not present" do
      it "returns false" do
        expect(hand.straight?).to eq(false)
      end
    end
  end

  describe "flush?" do
      it "returns a boolean"
    context "a flush is present" do
      it "returns true"
    end
    context "no flush is present" do
      it "returns false"
    end
  end

  describe "straight_flush?" do
      it "returns a boolean"
    context "a straight is present and a flush is present" do
      it "returns true"
    end
    context "straight and flush are not present" do
      it "returns false"
    end
  end

  describe "two_pair?" do
      it "returns a boolean"
    context "two pairs are present" do
      it "returns true"
    end
    context "two pairs are not present" do
      it "returns false"
    end
  end
  
  describe "three_of_a_kind?" do
      it "returns a boolean"
    context "three_of_a_kind is present" do
      it "returns true"
    end
    context "three_of_a_kind is not present" do
      it "returns false"
    end
  end

  describe "four_of_a_kind?" do
      it "returns a boolean"
    context "four_of_a_kind is present" do
      it "returns true"
    end
    context "four_of_a_kind is not present" do
      it "returns false"
    end
  end

  describe "full_house?" do
      it "returns a boolean"
    context "three_of_kind and separate pair is present" do
      it "check if pair is duplicated from three_of_a_kind"
      it "returns true"
    end
    context "three_of_kind and separate pair is not present" do
      it "returns false"
    end
  end

  describe "#hand_type" do
    it "calls #pair?"
    context "#pair? returns false" do
      it "calls #straight?"
      context "#straight? returns false" do
        it "calls #flush?"
        context "#flush returns false" do
          it "returns high_card"
        end
        context "#flush? returns true" do
          it "returns flush"
        end
      end
      context "#straight? returns true" do
        it "calls #flush"
        context "#flush? returns false" do
          it "returns straight"
        end
        context "#flush? returns true" do
          it "returns straight_flush"
        end
      end
    end
    context "#pair? returns true" do
      it "calls #three_of_a_kind"
      context "#three_of_a_kind? returns false" do
        it "calls #two_pair?"
        context "#two_pair? returns false" do
          it "returns pair"
        end
        context "#two_pair? returns true" do
          it "returns two_pair"
        end
      end
      context "three_of_a_kind? returns true" do
        it "calls #four_of_a_kind?"
        context "#four_of_a_kind? returns false" do
          it "calls #full_house?"
          context "#full_house? returns false" do
            it "returns three_of_a_kind"
          end
          context "#full_house? returns true" do
            it "returns full_house"
          end
        end
        context "#four_of_a_kind? returns true" do
          it "returns four_of_a_kind"
        end
      end
    end

    it "sets @hand_type as the highest scoring hand type held"
  end

  describe "#hand_score" do 
    it "calls #hand_type"
    it "returns value of @hand_type from HAND_SCORES and sets to @hand_score"
  end
end