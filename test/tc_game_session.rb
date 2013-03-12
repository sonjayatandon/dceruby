require "test/unit"

require "game_session"

class TestGameSession < Test::Unit::TestCase
  def setup
    @session = GameSession.new('MyGame')
  end
  
  def test_set_and_get
    #pass in bad parameters
    assert_nil(@session[nil])
    assert_nil(@session[''])
    
    #pass in a bogus tag
    assert_nil(@session['bogus'])
    
    #test 1rst generation set
    @session['num_turns'] = 5
    
    assert_equal(5, @session['num_turns'])
    
    @session['num_turns'] = nil
    assert_equal(nil, @session['num_turns'])
    
    
    #test 2nd generation set
    @session['board.players'] = 2
    
    assert_equal('board', @session['board'].name)
    assert_equal(2, @session['board.players'] )
    assert_nil(@session['foo.bar'])
    assert_nil(@session['board.onion'])
    
    @session['board.players'] = "for the win"
    assert_equal("for the win", @session['board.players'] )
    
    
    #test 3rd generation set
    @session['board.front_row.attackers'] = 5
    assert_equal('board', @session['board'].name)
    assert_equal('front_row', @session['board.front_row'].name)
    assert_equal(5, @session['board.front_row.attackers'] )
    
  end
  
  def test_get_action
    assert_equal('MyGame.attack(session)', GameSession.convert_action('MyGame','attack'))    
    
    assert_equal('MyGame.attack(session)', @session.get_action('attack'))
    assert_equal('MyGame.attack(session, 5)', @session.get_action('attack(5)'))
    assert_equal("MyGame.attack(session, 5, 'flying')", @session.get_action("attack(5, 'flying')"))
    assert_equal("MyGame.attack(session, 5, 'flying', :grounded)", @session.get_action("attack(5, 'flying', :grounded)"))
    assert_nil(@session.get_action("attack)(5)"))
  end
  
  def test_component_stack
    
  end
end