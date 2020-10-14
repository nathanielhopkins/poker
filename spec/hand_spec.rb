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
  let(:card10) {Card.new(5,:C)}
  let(:card11) {Card.new(2,:C)}
  let(:card12) {Card.new(2,:D)}
  let(:card13) {Card.new(6,:D)}
  let(:card14) {Card.new(14,:H)}
  subject(:hand) { Hand.new(card1,card2,card3,card4,card5)}
  let(:high_card_hand) {Hand.new(card1,card3,card4,card5,card6)}

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
    expect(Hand::HAND_SCORES).to match_array(HAND_SCORES)
  end

  describe "#initialize" do
    it "takes in five of cards" do
      expect{hand}.not_to raise_error
    end

    it "sets and reads @cards to array taken in as arg" do
      expect(hand.cards).to eq([card1,card2,card3,card4,card5])
    end

    it "sets and reads @high_card as highest value in hand" do
      expect(hand.high_card).to eq(13)
    end
  end

  describe "pair?" do
    it "returns a boolean" do
      expect(hand.pair?).to be(true).or be(false)
    end
    context "a pair is present" do
      it "sets and reads @match_value to value of highest pair" do
        hand.pair?
        expect(hand.match_value).to eq(2)
      end

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
        expect(hand.straight?).to be(true).or be(false)
      end
    context "a straight is present" do
      let(:straight_hand) {Hand.new(card1,card3,card7,card8,card13)}

      it "sets and reads @match_value to value of @high_card" do
        straight_hand.straight?
        expect(straight_hand.match_value).to eq(6)
      end

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
      it "returns a boolean" do
        expect(hand.flush?).to be(true).or be(false)
      end
    context "a flush is present" do
      let(:flush_hand) {Hand.new(card1,card3,card7,card8,card14)}

      it "sets and reads @match_value to value of @high_card" do
        flush_hand.flush?
        expect(flush_hand.match_value).to eq(14)
      end

      it "returns true" do
        expect(flush_hand.flush?).to eq(true)
      end
    end
    context "no flush is present" do
      it "returns false" do
        expect(hand.flush?).to eq(false)
      end
    end
  end

  describe "two_pair?" do
      it "returns a boolean" do
        expect(hand.two_pair?).to be(true).or be(false)
      end
    context "two pairs are present" do
      let(:two_pair_hand) {Hand.new(card1,card2,card3,card4,card10)}

      it "sets and reads @match_value to value of pair with highest value" do
        two_pair_hand.two_pair?
        expect(two_pair_hand.match_value).to eq(5)
      end

      it "returns true" do
        expect(two_pair_hand.two_pair?).to eq(true)
      end
    end
    context "two pairs are not present" do
      it "returns false" do
        expect(hand.two_pair?).to eq(false)
      end
    end
  end
  
  describe "three_of_a_kind?" do
      it "returns a boolean" do
        expect(hand.three_of_a_kind?).to be(true).or be(false)
      end
    context "three_of_a_kind is present" do
      let(:three_hand) {Hand.new(card1,card2,card3,card4,card11)}
      it "sets and reads @match_value to value of the three of a kind" do
        three_hand.three_of_a_kind?
        expect(three_hand.match_value).to eq(2)
      end
      it "returns true" do
        expect(three_hand.three_of_a_kind?).to eq(true)
      end
    end
    context "three_of_a_kind is not present" do
      it "returns false" do
        expect(hand.three_of_a_kind?).to eq(false)
      end
    end
  end

  describe "four_of_a_kind?" do
      it "returns a boolean" do
        expect(hand.four_of_a_kind?).to be(true).or be(false)
      end
    context "four_of_a_kind is present" do
      let(:four_hand) {Hand.new(card1,card2,card3,card11,card12)}
      
      it "sets and reads @match_value to value of the four of a kind" do
        four_hand.four_of_a_kind?
        expect(four_hand.match_value).to eq(2)
      end

      it "returns true" do
        expect(four_hand.four_of_a_kind?).to eq(true)
      end
    end
    context "four_of_a_kind is not present" do
      it "returns false" do
        expect(hand.four_of_a_kind?).to eq(false)
      end
    end
  end

  describe "full_house?" do
      it "returns a boolean" do
        expect(hand.full_house?).to be(true).or be(false)
      end
    context "three_of_kind and separate pair is present" do
      let(:full_house_hand) {Hand.new(card1,card2,card3,card10,card11)}
      let(:three_hand) {Hand.new(card1,card2,card3,card4,card11)}
      
      it "check if pair is duplicated from three_of_a_kind" do
        expect(three_hand.full_house?).to eq(false)
      end

      it "sets and reads @match_value to array [value of three, value of pair]" do
        full_house_hand.full_house?
        expect(full_house_hand.match_value).to eq([2,5])
      end

      it "returns true" do
        expect(full_house_hand.full_house?).to eq(true)
      end
    end
    context "three_of_kind and separate pair is not present" do
      it "returns false" do
        expect(hand.full_house?).to eq(false)
      end
    end
  end

  describe "#hand_type" do
    it "returns hand_type as a symbol"do
      expect(hand.hand_type).to be_an(Symbol)
    end
    context "#pair? returns false" do
      let(:straight_flush) {Hand.new(card1,card3,card7,card8,card9)}
      let(:flush) {Hand.new(card1,card3,card7,card8,card14)}
      let(:straight) {Hand.new(card1,card3,card7,card8,card13)}
      let(:straight_flush) {Hand.new(card1,card3,card7,card8,card9)}

      context "#straight? returns false" do
        context "#flush returns false" do
          it "returns high_card" do
            expect(high_card_hand.hand_type).to eq(:high_card)
          end
        end
        context "#flush? returns true" do
          it "returns flush" do
            expect(flush.hand_type).to eq(:flush)
          end
        end
      end
      context "#straight? returns true" do
        context "#flush? returns false" do
          it "returns straight" do
            expect(straight.hand_type).to eq(:straight)
          end
        end
        context "#flush? returns true" do
          it "returns straight_flush" do
            expect(straight_flush.hand_type).to eq(:straight_flush)
          end
        end
      end
    end
    context "#pair? returns true" do
      let(:three_hand) {Hand.new(card1,card2,card3,card4,card11)}
      let(:four_hand) {Hand.new(card1,card2,card3,card11,card12)}
      let(:two_pair_hand) {Hand.new(card1,card2,card3,card4,card10)}
      let(:full_house_hand) {Hand.new(card1,card2,card3,card10,card11)}

      context "#three_of_a_kind? returns false" do
        context "#two_pair? returns false" do
          it "returns pair" do
            expect(hand.hand_type).to eq(:pair)
          end
        end
        context "#two_pair? returns true" do
          it "returns two_pair" do
            expect(two_pair_hand.hand_type).to eq(:two_pair)
          end
        end
      end
      context "three_of_a_kind? returns true" do
        context "#four_of_a_kind? returns false" do
          context "#full_house? returns false" do
            it "returns three_of_a_kind" do
              expect(three_hand.hand_type).to eq(:three_of_a_kind)
            end
          end
          context "#full_house? returns true" do
            it "returns full_house" do
              expect(full_house_hand.hand_type).to eq(:full_house)
            end
          end
        end
        context "#four_of_a_kind? returns true" do
          it "returns four_of_a_kind" do
            expect(four_hand.hand_type).to eq(:four_of_a_kind)
          end
        end
      end
    end
  end

  describe "#hand_score" do 
    it "calls #hand_type to set and read @type" do
      hand.hand_score
      expect(hand.type).to eq(:pair)
    end
    it "retrieves value of @type from HAND_SCORES and sets to @hand_score" do
      expect(hand.hand_score).to eq(8)    
    end
  end

  describe "#show_hand" do
    it "returns an array of cards to_s (e.g. ['K♠','3♥','K♣','7♣','8♣']" do
      expect(hand.show_hand).to eq(["2♥","2♠","5♥","K♣","7♦"])
    end
  end
end