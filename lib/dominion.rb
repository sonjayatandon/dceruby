require 'game_component'
require 'game_session'

require 'yaml'

module Dominion
  def self.boo(session)
    puts "In boo #{session}"
  end
  
  def self.do_turn(session)
    puts "In do turn #{session}"
  end

  ########################################
  #  DEFINE THE PHASE COMMANDS
  def self.start_game(session)
    puts "Start game"
    
    session.push_action_list(session['phases'])
    
  end
  
  def self.start_turn(session)
    puts "start turn"
    5.times {self.draw_into_hand(session)}
  end
  
  def self.do_action(session)
    puts "do action"
  end
  
  def self.do_buy(session)
    puts "do buy"
  end
  
  def self.cleanup(session)
    puts "cleanup"
  end
  
  def self.end_turn(session)
    puts "end turn"
  end
  
  def self.end_game(session)
    puts "end game"
  end
  
  ########################################
  #  DEFINE THE GAME PLAY COMMANDS
  def self.draw_into_hand(session)
    deck = session['current-player.deck'] 
    discard = session['current-player.discard']
    hand = session['current-player.hand']
    
  end
  
  def self.add_to_property(session, property_name, amount)
    value = session[property_name] || 0
    value += amount
    session[property_name] = value
  end
  
  class GameDef
    @@filepath = nil
    def self.create_game_pieces()
      @@game_pieces={}
      
      @@filepath = File.join(APP_ROOT, 'lib/dominion.yaml')
      card_defs = YAML.load_file(@@filepath)
      
      card_defs.each do |config|
        name = config[:name]
        card = GameComponent.new(name.to_s,nil,nil,nil)
        
        config.each do |key, value|
          card[key.to_s] = value unless key == :name || key == :action
          if key == :action
            value.each do |trigger,action_list|
              action_list.each do |action|
                  card.add_action(trigger, GameSession.convert_action('Dominion', action))
              end
            end
          end
        end
        
        @@game_pieces[name] = card
      end
      
      @@game_pieces
    end

    def self.[](key)
      @@game_pieces[key]
    end

    def self.setup_board(session)
      num_players = session['definition.num-players']
      num_victory_cards = 8
      num_victory_cards = 12 unless num_players == 2
      
      ##### add the victory cards to the game board
      session.add_to_component_stack('victory-cards.estates', @@game_pieces[:estate], num_victory_cards)
      session.add_to_component_stack('victory-cards.duchies', @@game_pieces[:duchy], num_victory_cards)
      session.add_to_component_stack('victory-cards.province', @@game_pieces[:province], num_victory_cards)
      
      ##### add the treasure cards to the game board
      session.add_to_component_stack('treasure-cards.copper', @@game_pieces[:copper], 60)
      session.add_to_component_stack('treasure-cards.silver', @@game_pieces[:copper], 60)
      session.add_to_component_stack('treasure-cards.gold', @@game_pieces[:gold], 60)
      
      cstack = session['victory-cards.estates']
      puts "num estates=#{cstack.length}"
    end
    
    def self.initialize_turn_structure(session)
      phases = []
      phases << session.get_action('start_turn')
      phases << session.get_action('do_action')
      phases << session.get_action('do_buy')
      phases << session.get_action('cleanup')
      phases << session.get_action('end_turn')
      
      session['phases'] = phases
      
      session.queue_action(session.get_action('start_game'))
      session.queue_action(session.get_action('end_game'))
    end
  end
  
end