require "game"

describe "Game" do
  subject(:game) {Game.new(100,"Frank","Jim","Bob")}

  describe "#initialize" do
    it "takes in player pot size and names of players" do
      expect{game}.not_to raise_error
    end

    it "requires at least two players" do
      expect{Game.new(100,"Frank")}.to raise_error(ArguementError)
    end

    it "creates a new deck and holds and reads as @deck" do
      expect(game.deck).to be_an(Deck)
    end

    it "creates and reads @pot starting as 0" do
      expect(game.pot).to eq(0)
    end 

    it "creates and reads @players as an hash {player_name: Player.new(player_pot,player_name)}" do
      expect(game.players.keys).to eq(["Frank","Jim","Bob"])
      expect(game.players["Frank"]).to be_an(Player)
    end

    it "creates and reads @current_player, initializing as value of first @player" do
      expect(game.current_player).to eq(game.players[game.players.first])
    end
  end

  describe "#pot=(value)" do
    it "sets pot to new value" do
      game.pot = 250
      expect(game.pot).to eq(250)
    end
  end

  describe "#switch_player" do
    it "rotates @players so first player is now last" do
      game.switch_player
      expect(game.players.keys).to eq(["Jim","Bob","Frank"])
    end

    it "resets @current_player to new first player" do
      game.switch_player
      expect(game.current_player).to eq(game.players[game.players.first])
    end
  end

  describe "#deal_em" do
    it "sets @pot back to 0" do
      game.instance_variable_set(:@pot, 200)
      game.deal_em
      expect(game.pot).to eq(0)
    end

    it "sets @current_bet to 10 (round ante)" do
      game.deal_em
      expect(game.current_bet).to eq(10)
    end

    it "sets and reads @players_in_hand to equal @players.values" do
      game.deal_em
      expect(game.players_in_hand).to eq(game.players.values)
    end

    it "creates a new Deck and shuffles" do
      old_deck = game.deck.dup
      game.deal_em
      expect(game.deck).not_to eq(old_deck)
    end
    it "calls deck#deal to deal each player 5 cards"  do
      game.deal_em
      expect(game.deck.cards.length).to eq(37)
      expect(game.current_player.cards).not_to be_empty
    end
    it "calls player#new_hand on each player so their hand is their dealt cards" do
      game.deal_em
      expect(game.current_player.hand).not_to eq(nil)
    end
  end

  describe "#show_turn" do
    it "Says whose turn it is, calls and prints hand#show_hand, and waits for player to hit Enter to continue" do
      allow_any_instance_of(Game).to receive(:gets).and_return(true)
      expect(game.show_turn).to eq(true)
    end
  end

  describe "#draw_phase" do
    it "calls #show_turn" do
      allow_any_instance_of(Game).to receive(:draw_phase).and_return(true)
      expect(game.draw_phase).to eq(true)
    end
    it "calls player#discard_phase for current player" do
      allow_any_instance_of(Player).to receive(:discard_phase).and_return(game.current_player.cards[0])
      expect(game.current_player.cards.length).to eq(4)
    end
    it "deals new cards to current player to replace discarded cards" do
      allow_any_instance_of(Deck).to receive(:deal).and_return("dummy_card")
      expect(game.current_player.cards[4]).to eq("dummy_card")
    end
    it "calls show_turn again" do
      allow_any_instance_of(Game).to receive(:draw_phase).and_return(true)
      expect(game.draw_phase).to eq(true)
    end
  end

  describe "#bet_display" do
    it "prints who is betting, shows player bet, shows current bet, and wait for player to hit Enter to continue." do
      allow_any_instance_of(Game).to receive(:gets).and_return(true)
      expect(game.bet_display).to eq(true)
    end
  end

  describe "#ante_up" do
    it "sets @bet for each player to eq 10" do
      game.ante_up
      expect(game.current_player.bet).to eq(10)
    end

    it "moves 10 from each players pot to the game pot" do
      game.ante_up
      expect(game.current_player.pot).to eq(90)
    end
  end

  describe "#bet_from_player" do
    it "calls #bet_display and current_player#get_action" do
      allow_any_instance_of(Player).to receive(:gets).and_return("see")
      game.bet_from_player
      expect(game.current_player.current_action).to eq(:see)
    end
    context "player's bet is equal to current bet" do
      context "#get_action returns :see" do
        it "keeps player in hand" do
          allow_any_instance_of(Player).to receive(:gets).and_return("see")
          game.current_player.instance_variable_set(:bet,10)
          game.instance_variable_set(:current_bet, 10)
          game.bet_from_player
          expect(game.players_in_hand).to include(game.current_player)
        end
      end
      context "#get_action returns :fold" do
        it "removes player from hand" do
          allow_any_instance_of(Player).to receive(:gets).and_return("fold")
          game.bet_from_player
          expect(game.players_in_hand).not_to include(game.current_player)
        end
      end
      context "#get_action returns :raise" do
        context "asks user for raise amount and raise exceeds player's pot" do
          it "raises error and gets new bet" do
            allow_any_instance_of(Player).to receive(:gets).and_return("raise","raise",100000,10)
            expect{game.bet_from_player}.not_to raise_error
          end
        end
        context "asks user for raise amount and raise does not exceed player's pot" do
          it "raises current game bet to player bet" do
            allow_any_instance_of(Player).to receive(:gets).and_return("raise","raise", 10)
            game.instance_variable_set(:@current_bet, 10)
            game.current_player.instance_variable_set(:@bet,10)
            game.bet_from_player
            expect(game.current_bet).to eq(20)
          end
          it "moves difference from players pot to game pot" do
            allow_any_instance_of(Player).to receive(:gets).and_return("raise","raise",10)
            game.instance_variable_set(:@current_bet, 10)
            game.current_player.instance_variable_set(:@bet,10)
            game.bet_from_player
            expect(game.current_player.pot).to eq(80)
          end
          it "keeps player in hand" do
            allow_any_instance_of(Player).to receive(:gets).and_return("raise")
            game.bet_from_player
            expect(game.players_in_hand).to include(game.current_player)
          end
        end
      end
    end
    
    context "player's bet is less than current bet" do
      context "#get_action returns :see" do
        it "raises player bet to equal current bet" do
          allow_any_instance_of(Player).to recieve(:gets).and_return("see")
          game.instance_variable_set(:@current_bet, 20)
          game.current_player.instance_variable_set(:@bet,10)
          game.bet_from_player
          expect(game.current_player.pot).to eq(80)
        end

        it "moves difference from players pot to game pot"
        it "keeps player in hand"
      end
      context "#get_action returns :fold" do
        it "removes player from hand"
      end
      context "#get_action returns :raise" do
        it "raises current game bet to player bet"
        it "moves difference from players pot to game pot"
        it "keeps player in hand"
      end
    end
  end

  describe "#bet_phase" do
    it "calls #bet_from_player for each @players_in_hand"
    it "calls #bet_from_player until everyone has seen or folded"
  end

  describe "#show_em" do
    it "prints each player still in hand with thier cards (hand#show_hand)"
    context "one hand has the best(lowest) hand_score" do
      it "declares that hand the winner"
    end
    context "two hands have the best and same hand_score" do
      context "one hand has higher match_value" do
        it "declares higher match_value hand as winner"
      end
      context "match_values are equal" do
        context "one hand as higher high_card" do
          it "declares the higher high_card hand the winner"
        end
        context "high_cards are the same" do
           it "declares a draw and splits the pot"
        end
      end
    end
  end

  describe "#play_hand" do
    it "calls #deal_em"
    it "calls #ante_up"
    it "calls #bet_phase until everyone has seen bet or folded"
    it "calls #draw_phase and #switch_player for each player"
    it "calls #bet_phase until everyone has seen bet or folded"
    it "calls #show_em"
    it "removes any players from @players whose pots < 10 (round ante)"
  end

  describe "#play" do
    it "calls #play_hand until only one player remains"
    it "declares last remaining player as winner and returns 'Game Over'"
  end
end