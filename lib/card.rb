class Card
  attr_reader :value, :suit

  def initialize(value,suit)
    @value = value
    @suit = suit
  end

  def symbol
    case @suit
    when :S
      "♠"
    when :H
      "♥"
    when :D
      "♦"
    when :C
      "♣"
    end
  end

  def to_s
    "#{value.to_s}#{symbol}"
  end
end