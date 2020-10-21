require_relative "deck"
require_relative "hand"

class Player
  attr_reader :hand, :bet
  attr_accessor :cards, :pot, :current_action

  def initialize(hand, pot)
    @hand = hand
    @cards = []
    @cards = @hand.cards if @hand
    @pot = pot
    @current_action = :none
  end

  def bet=(value)
    @bet = value
  end

  def new_hand
    @hand = Hand.new(@cards[0],@cards[1],@cards[2],@cards[3],@cards[4])
  end

  def discard_phase
    discard_display
    input = discard_input
    if input == 'none'
      return false
    else
      discard(input)
      return input
    end
  end

  def discard(array_of_cards)
    new_cards = @cards - array_of_cards
    @cards = new_cards
  end

  def discard_display
    puts "1 = #{cards[0].to_s}"
    puts "2 = #{cards[1].to_s}"
    puts "3 = #{cards[2].to_s}"
    puts "4 = #{cards[3].to_s}"
    puts "5 = #{cards[4].to_s}"
    puts "Please select up to three cards to discard, separated by commas (e.g. card1,card4). Write 'none' if you wish to keep hand."
  end

  def discard_input
    valid_cards = ['1','2','3','4','5']
    input = gets.chomp
    if input.split(",").all? {|el| valid_cards.include?(el)} && input.split(',').length <= 3  
      input = input.split(",").map(&:to_i)
      return input.map {|num| @cards[num - 1]}
    elsif input == 'none'
      return input
    else 
      raise "invalid input"
    end
  rescue StandardError
    retry
  end

  def get_action
    action = gets.chomp
    case action
    when 'fold'
      @current_action = :fold
      return :fold
    when 'see'
      @current_action = :see
      return :see
    when 'raise'
      @current_action = :raise
      return :raise
    else
      raise "invalid action"
    end
    rescue StandardError
    retry
  end

  def reset_action
    @current_action = :none
  end
end