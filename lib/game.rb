require_relative "player"

class Game
  attr_reader :deck, :players, :current_player, :players_in_hand
  attr_accessor :pot, :current_bet

  def initialize(player_pot,player1,player2,*other_players)
    @deck = Deck.new
    @pot = 0
    @players = Hash.new
    player_names = [player1, player2] + other_players
    player_names.each {|player| @players[player] = Player.new(nil, player_pot)}
    @current_player = @players.values.first
  end

  def switch_player
    @players = Hash[@players.to_a.rotate]
    @current_player = @players.values.first
  end

  def deal_em
    @pot = 0
    @players_in_hand = @players.values
    @deck = Deck.new
    @deck.shuffle
    @players_in_hand.each do |player| 
      player.cards = @deck.deal(5)
      player.new_hand
    end
  end

  def show_turn
    puts "#{@players.key(@current_player)}'s hand: #{@current_player.hand.show_hand}"
    gets
  end

  def draw_phase
    show_turn
    discard = @current_player.discard_phase
    if discard != false
      new_cards = @deck.deal(discard.length)
      @current_player.cards += @deck.deal(discard.length)
      @current_player.new_hand
    end
    show_turn
  end

  def ante_up
    @current_bet = 10
    @players.values.each do |player| 
      player.bet = 10
      player.pot -= 10
      @pot += 10
    end
  end

  def bet_display
    show_turn
    puts "#{@players.key(@current_player)}'s pot: #{@current_player.pot}"
    puts "#{@players.key(@current_player)}'s bet: #{@current_player.bet}"
    puts "Current game bet: #{@current_bet}"
    puts "Press Enter to continue."
    gets
    puts "Would you like to 'see','fold',or 'raise'?"
    true
  end

  def raise_prompt
    puts "How much would you like to raise? (e.g. 10)"
    bet = gets.to_i
    raise "You don't have that much to bet." if bet > @current_player.pot
    bet
  rescue
  retry
  end

  def bet_from_player
    bet_display
    action = @current_player.get_action
    case action
    when :see
      if @current_player.bet < @current_bet
        difference = @current_bet - @current_player.dup.bet
        @current_player.bet += difference
        @pot += difference
        @current_player.pot -= difference
      end
    when :raise
      bet = raise_prompt
      @current_bet += bet
      difference = @current_bet - @current_player.dup.bet
      @current_player.bet = @current_bet
      @pot += difference
      @current_player.pot -= difference
    when :fold
      @players_in_hand.delete(@current_player)
    end
  end

  def bet_phase
    @players.values.each {|player| player.current_action = :none}
    until @players_in_hand.all? {|player| player.current_action == :see} || @players_in_hand.length <= 1
      @players_in_hand.length.times do
        bet_from_player
        switch_player
      end
    end
    true
  end

  def show_em_display
    @players_in_hand.each do |player|
      puts "#{@players.key(player)}'s hand: #{player.hand.show_hand}'"
    end
    true
  end

  def show_em
    show_em_display
    best_score = 10
    self.players_in_hand.each do |player|
      score = player.hand.hand_score
      best_score = score if score < best_score
    end
    best_hand_scores = self.players_in_hand.select {|player| player.hand.hand_score == best_score}
    best_match_value = 1
    best_hand_scores.each do |player|
      value = player.hand.match_value
      best_match_value = value if value > best_match_value
    end
    best_match_values = best_hand_scores.select {|player| player.hand.match_value == best_match_value}
    best_high_card = 1
    best_match_values.each do |player|
      high_card = player.hand.high_card
      best_high_card = high_card if high_card > best_high_card
    end
    best_high_cards = best_match_values.select {|player| player.hand.high_card == best_high_card}
  end

  def pay_out(winners_array)
    each_pot = @pot / winners_array.length
    winners_array.each {|player| player.pot += each_pot}
  end

  def play_hand
    deal_em
    ante_up
    bet_phase
    @players_in_hand.each do |player|
      draw_phase
      switch_player
    end
    bet_phase
    winner = show_em
    pay_out(winner)
    winner_names = winner.map {|winner| @players.key(winner)}
    puts "#{winner_names.join(" and ")} wins #{@pot} with a #{@current_player.hand.hand_type}. Press Enter to continue."
    gets
    out = @players.select {|k,v| v.pot < 10}
    if out.empty? == false
      out_names = out.keys.join(" and ")
      puts "#{out_names} busted out with nothing left to bet. Press Enter to continue."
      out.keys.each {|out| @players.delete(out)}
      gets
    end
    true
  end

  def play
    until @players.keys.length == 1
      play_hand
    end
    puts "#{@players.keys.first} is the Winner!!!"
    "Game Over"
  end
end