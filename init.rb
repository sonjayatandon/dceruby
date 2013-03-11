############ board game engine
#
#
#

APP_ROOT = File.dirname(__FILE__)

$:.unshift(File.join(APP_ROOT, 'lib'))

require 'gamesession'
require 'dominion'

puts 'Initializing game definition'
Dominion::GameDef.create_game_pieces()
puts Dominion::GameDef[:estate].name

puts 'Creating new game session \n'
session = GameSession.new('Dominion')

puts 'Setting up board \n'
session['definition.starting_kingdom_cards'] = [:market,:council]

# Dominion::GameDef.setup_board(session)
Dominion::GameDef.initialize_turn_structure(session)

puts 'Ready to play'

session.do_next_action()