require 'gamecomponent'

class GameSession
  def initialize(game_module)
    @game_board = GameComponent.new('',self,nil,nil)
    @game_module = game_module
    @execution_queue = []
  end
  
  def add_component(key, new_component, prototype)
    sub_key_list = key.split('.');
    num_sub_keys = sub_key_list.length
    
    component = @game_board
    generation=1

    sub_key_list.each do |sub_key|
      child = component.child(sub_key)
      if generation==num_sub_keys
        child = component.add_child(sub_key,GameComponent.new(sub_key, self, component,prototype))
      elsif child==nil
        child = component.add_child(sub_key,GameComponent.new(sub_key, self, component,nil))
      end
      component=child
      generation+=1
    end
    component
  end
  
  def []= (key, value) 
    sub_key_list = key.split('.');
    num_sub_keys = sub_key_list.length
    
    component = @game_board
    generation=1

    sub_key_list.each do |sub_key|
      child = component.child(sub_key)
      if generation==num_sub_keys
        component[sub_key]=value
      elsif child==nil
        child = component.add_child(sub_key,GameComponent.new(sub_key, self, component,nil))
        component=child
      else
        component=child
      end
      generation+=1
    end
    component
  end
  
  def [] (key)
    sub_key_list = key.split('.');
    num_sub_keys = sub_key_list.length
    
    component = @game_board
    generation=1

    sub_key_list.each do |sub_key|
      child = component.child(sub_key)
      if child==nil && generation==num_sub_keys
        return component[sub_key]
      end
      
      component=child
      generation+=1
    end
    
    return component
  end
  
  def get_action(action_name)
    # changes this to be module.action_name(session[,optional parameters])
    "#{@game_module}.#{action_name}(session)"
  end
  
  def queue_action(action)
     @execution_queue << action
  end
  
  def push_action_list(action_list)
    i = 0;
    action_list.each do |a|
      @execution_queue.insert(i,a)
      i+=1
    end
  end
  
  def do_next_action()
    session = self
  
    @event_queue = []
    
    while @event_queue.length == 0 && @execution_queue.length > 0
      action = @execution_queue.delete_at(0)
      puts "Executing: #{action}"
      eval(action)
    end
    
    @event_queue
     
  end
end