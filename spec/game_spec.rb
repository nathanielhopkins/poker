require "game"

describe "Game" do
  subject(:game) {Game.new(100,"Frank","Jim","Bob")}

  describe "#initialize" do
    it "takes in player pot size and names of players" do
      expect{game}.not_to raise_error
    end

    it "requires at least two players" do
      expect{Game.new(100,"Frank")}.to raise_error(ArgumentError)
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
      expect(game.current_player).to eq(game.players.values.first)
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
      expect(game.current_player).to eq(game.players.values.first)
    end
  end

  describe "#deal_em" do
    it "sets @pot back to 0" do
      game.instance_variable_set(:@pot, 200)
      game.deal_em
      expect(game.pot).to eq(0)
    end

    it "sets and reads @players_in_hand to equal @players.values" do
      game.deal_em
      expect(game.players_in_hand).to eq(game.players.values)
    end

    it "creates a new Deck and shuffles" do
      old_deck = game.deck.dup
      game.deal_em
      expect(game.deck.cards).not_to eq(old_deck.cards)
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
    it "Tells whose turn it is and shows hand" do
      game.deal_em
      allow_any_instance_of(Game).to receive(:gets).and_return(true)
      allow_any_instance_of(Hand).to receive(:show_hand).and_return("nada")
      expect(game.show_turn).to eq(true)
    end
  end

  describe "#draw_phase" do
    it "calls #show_turn" do
      allow_any_instance_of(Game).to receive(:gets).and_return(true)
      allow_any_instance_of(Game).to receive(:show_turn).and_return(true)
      allow_any_instance_of(Player).to receive(:discard_phase).and_return(false)
      expect(game.draw_phase).to eq(true)
    end 

    it "calls player#discard_phase for current player" do
      allow_any_instance_of(Game).to receive(:show_turn).and_return(true)
      allow_any_instance_of(Player).to receive(:discard_phase).and_return(false)
      expect(game.draw_phase).to eq(true)
    end
    it "deals new cards to current player to replace discarded cards" do      
    end
    it "calls show_turn again" do
      allow_any_instance_of(Game).to receive(:gets).and_return(true)
      allow_any_instance_of(Game).to receive(:show_turn).and_return(true)
      allow_any_instance_of(Player).to receive(:discard_phase).and_return(false)
      expect(game.draw_phase).to eq(true)
    end
  end

  describe "#ante_up" do
    it "sets @current_bet to 10 (round ante)" do
      game.ante_up
      expect(game.current_bet).to eq(10)
    end

    it "sets @bet for each player to eq 10" do
      game.ante_up
      expect(game.current_player.bet).to eq(10)
    end

    it "moves 10 from each players pot to the game pot" do
      game.ante_up
      expect(game.current_player.pot).to eq(90)
    end
  end

  describe "#bet_display" do
    it "prints who is betting, shows player bet, shows current bet, and Press Enter to continue." do
      allow_any_instance_of(Game).to receive(:gets).and_return(true)
      expect(game.bet_display).to eq(true)
    end
  end

  describe "#raise_prompt" do
    it "prompts user for raise amount and gets and returns input from user" do
      allow_any_instance_of(Game).to receive(:gets).and_return(10)
      expect(game.raise_prompt).to eq(10)
    end

    it "raises error, rescues, and retries if amount is more than player's pot" do
      allow_any_instance_of(Game).to receive(:gets).and_return(1000,10)
      expect{game.raise_prompt}.not_to raise_error
      expect(game.raise_prompt).to eq(10)
    end
  end

  describe "#bet_from_player" do
    it "calls #bet_display and current_player#get_action" do
      allow_any_instance_of(Game).to receive(:bet_display).and_return(true)
      allow_any_instance_of(Player).to receive(:gets).and_return("see")
      game.bet_from_player
      expect(game.current_player.current_action).to eq(:see)
    end

    context "player's bet is equal to current bet" do
      context "#get_action returns :see" do
        it "keeps player in hand" do
          allow_any_instance_of(Game).to receive(:bet_display).and_return(true)
          allow_any_instance_of(Player).to receive(:gets).and_return("see")
          game.deal_em
          game.ante_up
          game.bet_from_player
          expect(game.players_in_hand).to include(game.current_player)
        end
      end
    end
    
    context "player's bet is less than current bet" do
      context "#get_action returns :see" do
        it "raises player bet to equal current bet" do
          allow_any_instance_of(Player).to recieve(:gets).and_return("see")
          allow_any_instance_of(Game).to receive(:bet_display).and_return(true)
          game.deal_em
          game.ante_up
          game.current_bet = 20
          game.bet_from_player
          expect(game.current_player.bet).to eq(20)
        end

        it "moves difference from players pot to game pot" do
          allow_any_instance_of(Player).to recieve(:gets).and_return("see")
          game.deal_em
          game.ante_up
          game.current_bet = 20
          game.bet_from_player
          expect(game.current_player.pot).to eq(80)
          expect(game.pot).to eq(40)
        end
        
        it "keeps player in hand" do
          allow_any_instance_of(Player).to recieve(:gets).and_return("see")
          game.deal_em
          game.ante_up
          game.current_bet = 20
          game.bet_from_player
          expect(game.players_in_hand).to include(game.current_player)
        end
      end
    end

    context "#get_action returns :fold" do
        it "removes player from hand" do
          allow_any_instance_of(Game).to receive(:bet_display).and_return(true)
          allow_any_instance_of(Player).to receive(:gets).and_return("fold")
          game.deal_em
          game.bet_from_player
          expect(game.players_in_hand).not_to include(game.current_player)
        end
      end

    context "#get_action returns :raise" do
      it "raises current game bet to player bet" do
        allow_any_instance_of(Game).to receive(:bet_display).and_return(true)
        allow_any_instance_of(Player).to receive(:gets).and_return("raise")
        allow_any_instance_of(Game).to receive(:raise_prompt).and_return(10)
        game.deal_em
        game.ante_up
        game.bet_from_player
        expect(game.current_bet).to eq(20)
      end

      it "moves difference from players pot to game pot" do
        allow_any_instance_of(Game).to receive(:bet_display).and_return(true)
        allow_any_instance_of(Player).to receive(:gets).and_return("raise")
        allow_any_instance_of(Game).to receive(:raise_prompt).and_return(10)
        game.deal_em
        game.ante_up
        game.bet_from_player
        expect(game.current_player.pot).to eq(80)
      end

      it "keeps player in hand" do
        allow_any_instance_of(Game).to receive(:bet_display).and_return(true)
        allow_any_instance_of(Player).to receive(:gets).and_return("raise")
        allow_any_instance_of(Game).to receive(:raise_prompt).and_return(10)
        game.deal_em
        game.ante_up
        game.bet_from_player
        expect(game.players_in_hand).to include(game.current_player)
      end
    end
  end

  describe "#bet_phase" do
    it "calls #bet_from_player for each @players_in_hand" do
      allow_any_instance_of(Player).to receive(:gets).and_return("see")
      game.instance_variable_set(:@current_bet,10)
      game.bet_phase
      expect(game.pot).to eq(30)
      expect(game.current_player.pot).to eq(90)
    end
    it "calls #bet_from_player until everyone has seen or folded then returns true" do
      allow_any_instance_of(Player).to receive(:gets).and_return("see")
      game.instance_variable_set(:@current_bet,10)
      game.bet_phase
      expect(game.bet_phase).to eq(true)
    end
  end

  describe "#show_em" do
    it "prints each player still in hand with thier cards (hand#show_hand), compares hands, and returns winner(s) as array" do
      expect(game.show_em).to be_an(Array)
    end
    context "one hand has the best(lowest) hand_score" do
      it "returns player with best hand_score" do
        allow_any_instance_of(Game).to receive(:players_in_hand).and_return([Bob,Frank])
        allow(Bob).to receive(:hand_score).and_return(3)
        allow(Frank).to receive(:hand_score).and_return(5)
        expect(game.show_em).to eq([Bob])
      end
    end
    context "two hands have the best and same hand_score" do
      context "one hand has higher match_value" do
        it "returns the player with higher match_value hand" do
        allow_any_instance_of(Game).to receive(:players_in_hand).and_return([Bob,Frank])
        allow(Bob).to receive(:hand_score).and_return(5)
        allow(Frank).to receive(:hand_score).and_return(5)
        allow(Bob).to receive(:match_value).and_return(2)
        allow(Frank).to receive(:match_value).and_return(12)
        expect(game.show_em).to eq([Frank])
        end
      end
      context "match_values are equal" do
        context "one hand as higher high_card" do
          it "returns the player with the higher high_card hand" do
            allow_any_instance_of(Game).to receive(:players_in_hand).and_return([Bob,Frank])
            allow(Bob).to receive(:hand_score).and_return(5)
            allow(Frank).to receive(:hand_score).and_return(5)
            allow(Bob).to receive(:match_value).and_return(2)
            allow(Frank).to receive(:match_value).and_return(2)
            allow(Bob).to receive(:high_card).and_return(7)
            allow(Frank).to receive(:high_card).and_return(12)
            expect(game.show_em).to eq([Frank])
          end
        end
        context "high_cards are the same" do
           it "returns array of tying winners" do
            allow_any_instance_of(Game).to receive(:players_in_hand).and_return([Bob,Frank])
            allow(Bob).to receive(:hand_score).and_return(5)
            allow(Frank).to receive(:hand_score).and_return(5)
            allow(Bob).to receive(:match_value).and_return(2)
            allow(Frank).to receive(:match_value).and_return(2)
            allow(Bob).to receive(:high_card).and_return(7)
            allow(Frank).to receive(:high_card).and_return(7)
            expect(game.show_em).to eq([Bob,Frank])
           end
        end
      end
    end
  end

  describe "#pay_out" do
    it "takes in array containing one or more players" do
      expect{game.pay_out([player])}.not_to raise_error
      expect{game.pay_out([player1,player2])}.not_to raise_error
    end

    context "one player is given" do
      it "pays out entire pot to player's pot" do
        game.instance_variable_set(:@pot, 50)
        game.pay_out([game.current_player])
        expect(game.current_player.pot).to eq(150)
      end
    end

    context "two or more players are given" do
      it "splits the pot evenly among given players" do
        game.instance_variable_set(:@pot, 40)
        frank = instance_double("Frank", :pot => 0)
        bob = instance_double("Bob", :pot => 0)
        game.pay_out([frank,bob])
        expect(frank.pot).to eq(20)
        expect(bob.pot).to eq(20)
      end
    end
  end

  describe "#play_hand" do
    it "calls #deal_em" do
      allow_any_instance_of(Game).to receive(:deal_em).and_return(true)
      expect(game.play_hand).to eq(true)
    end
    it "calls #ante_up" do
      allow_any_instance_of(Game).to receive(:ante_up).and_return(true)
      expect(game.play_hand).to eq(true)
    end
    it "calls #bet_phase until everyone has seen bet or folded" do
      allow_any_instance_of(Game).to receive(:bet_phase).and_return(true)
      expect(game.play_hand).to eq(true)
    end
    it "calls #draw_phase and #switch_player for each player" do
      allow_any_instance_of(Game).to receive(:draw_phase).and_return(true)
      allow_any_instance_of(Game).to receive(:switch_player).and_return(true)
      expect(game.play_hand).to eq(true)
    end
    it "calls #bet_phase until everyone has seen bet or folded" do
      allow_any_instance_of(Game).to receive(:bet_phase).and_return(true)
      expect(game.play_hand).to eq(true)
    end
    it "calls #show_em" do
      allow_any_instance_of(Game).to receive(:show_em).and_return(true)
      expect(game.play_hand).to eq(true)
    end
    it "removes any players from @players whose pots < 10 (round ante)" do
      game.current_player.instance_variable_set(:@pot, 4)
      expect(game.players.length).to eq(2)
    end
  end

  describe "#play" do
    it "calls #play_hand until only one player remains" do
      allow_any_instance_of(Game).to receive(:play_hand).and_return(true)
      expect(game.play).to eq(true)
    end
    it "declares last remaining player as winner and returns 'Game Over'"do
      bob = instance_double("Bob", :pot => 20)
      game.instance_variable_set(:@players, [bob])
      expect(game.play).to eq('Game Over')
    end
  end
end