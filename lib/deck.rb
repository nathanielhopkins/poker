require_relative "card"

class Deck
  attr_reader :cards, :discard
  SUITS = [:H,:D,:S,:C]
  VALUES = (2..14).to_a

  def initialize
    @cards = fill_deck
    @discard = []
  end

  def fill_deck
    cards = []
    SUITS.each do |suit|
      VALUES.each do |value|
        cards << Card.new(value, suit)
      end
    end
    cards
  end

  def shuffle
    @cards = @cards.shuffle
  end

  def deal(num)
    @cards.pop(num)
  end

end