require_relative "card"

class Hand

  attr_reader :cards, :high_card, :match_value, :type

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

  def initialize(card1,card2,card3,card4,card5)
    @cards = [card1,card2,card3,card4,card5]
    high_card = @cards.map{|card| card.value}.max
    @high_card = high_card
  end

  def pair?
    counts = Hash.new(0)
    @cards.each { |card| counts[card.value] += 1 }
    counts.select! {|k,v| v >= 2}
    if !counts.empty?
      @match_value = counts.keys.max
      return true
    else
      return false
    end
  end

  def straight?
    straight_sort = @cards.map {|card| card.value}.sort
    straight_sort[0..3].each_with_index do |value, i|
      return false if straight_sort[i+1] != (value + 1)
    end
    @match_value = @high_card
    true
  end

  def flush?
    if @cards.all? {|card| card.suit == @cards[0].suit}
      @match_value = @high_card
      return true
    else
      return false
    end
  end

  def two_pair?
    counts = Hash.new(0)
    @cards.each { |card| counts[card.value] += 1 }
    counts.select! { |k,v| counts[k] == 2}
    if counts.length == 2
      @match_value = counts.keys.max  
      return true
    else
      return false
    end
  end

  def three_of_a_kind?
    counts = Hash.new(0)
    @cards.each { |card| counts[card.value] += 1 }
    counts.select! {|k,v| v >= 3}
    if !counts.empty?
      @match_value = counts.keys.max
      return true
    else
      return false
    end
  end

  def four_of_a_kind?
    counts = Hash.new(0)
    @cards.each { |card| counts[card.value] += 1 }
    counts.select! {|k,v| v >= 4}
    if !counts.empty?
      @match_value = counts.keys.max
      return true
    else
      return false
    end
  end

  def full_house?
    counts = Hash.new(0)
    @cards.each { |card| counts[card.value] += 1 }
    if counts.has_value?(3) && counts.has_value?(2)
      @match_value = [counts.key(3),counts.key(2)]
      return true
    else
      return false
    end
  end

  def hand_type
    case pair?
    when false
      case straight?
      when false
        case flush?
        when false
          @match_value = @high_card
          return :high_card
        when true
          return :flush
        end
      when true #straight
        case flush?
        when false
          return :straight
        when true
          return :straight_flush
        end
      end
    when true #pair
      case three_of_a_kind?
      when false
        case two_pair?
        when false
          return :pair
        when true
          return :two_pair
        end
      when true #three_of_a_kind
        case four_of_a_kind?
        when false
          case full_house?
          when false
            return :three_of_a_kind
          when true
            return :full_house
          end
        when true #four_of_a_kind
          return :four_of_a_kind
        end
      end
    end
  end

  def hand_score
    @type = hand_type
    @hand_score = HAND_SCORES[@type]
  end

  def show_hand
    @cards.map {|card| card.to_s}
  end
end