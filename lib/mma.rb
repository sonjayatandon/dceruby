require 'game_component'
require 'game_session'

require 'yaml'

module MMA

  def self.start_match(session)
    puts "start match"
  end

  def self.start_round(session)
    puts "start round"
  end

  def self.do_turn(session)
    puts "do_turn"
  end

  def self.end_round(session)
    puts "end round"
  end

  def self.end_match(session)
    puts "end match"
  end


  class GameDef
    def self.initialize_turn_structure(session)
      session.queue_action(session.get_action('start_match'))
      session.queue_action(session.get_action('start_round'))
      session.queue_action(session.get_action('do_turn'))
      session.queue_action(session.get_action('end_round'))
      session.queue_action(session.get_action('end_match'))
    end
  end
end