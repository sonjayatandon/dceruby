############ board game engine
#
#
#

APP_ROOT = File.dirname(__FILE__)

$:.unshift(File.join(APP_ROOT, 'lib'))

require 'game_session'
require 'dominion'

puts 'Initializing game definition'
Dominion::GameDef.create_game_pieces()

card = Dominion::GameDef[:copper]
puts "card=#{Dominion::GameDef[:copper].name}" 
card.pp.each do |line|
  puts line
end


puts 'Creating new game session \n'
session = GameSession.new('Dominion')

puts 'Setting up board \n'
session['definition.starting_kingdom_cards'] = [:market,:council]
session['definition.num-players'] = 2

Dominion::GameDef.setup_board(session)
Dominion::GameDef.initialize_turn_structure(session)

puts 'Ready to play'

puts 'some bogus message'

session.do_next_action()