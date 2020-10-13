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
    if @value > 10
      case @value
      when 11
        face_value = "J"
      when 12
        face_value = "Q"
      when 13
        face_value = "K"
      when 14
        face_value = "A"
      end
      "#{face_value}#{symbol}"
    else
      "#{value.to_s}#{symbol}"
    end
  end
end