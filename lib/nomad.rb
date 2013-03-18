module Nomad
  def self.set_phase(session, phase_name)
    puts "Starting phase #{phase_name}"
  end

  def self.upkeep(session)

  end

  def self.cleanup(session)

  end

  def self.start_round(session)

  end

  class GameDef
    def self.initialize_turn_structure(session)
      session.queue_action(session.get_action("set_phase('START ROUND')"))
      session.queue_action(session.get_action('upkeep'))
      session.queue_action(session.get_action('cleanup'))
      session.queue_action(session.get_action('start_round'))
    end
  end

end