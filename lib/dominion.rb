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