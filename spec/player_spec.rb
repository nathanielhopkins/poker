require "player"

describe "Player" do

  describe "#initialize" do
    let(:player) {Player.new(hand,pot)}
    it "takes in a hand and a pot" do
      expect{player}.not_to raise_error
    end

    it "sets and reads @hand as received hand" do
      expect(player.hand).to eq(hand)
    end

    it "sets and reads @pot as received pot" do
      expect(player.pot).to eq(pot)
    end
  end

  describe "#discard" do
  end
end