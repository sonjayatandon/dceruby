require 'game_component'
require 'game_component_stack'

class GameSession
  def self.convert_action(module_name, action_name)
    # changes this to be module.action_name(session[,optional parameters])
    
    #check for optional parameters
    pindex = action_name.index('(')
    if pindex
      return nil unless action_name.index(')') && action_name.index(')') > pindex
      arg_str = action_name[pindex+1..action_name.length-2]
      action_name = action_name[0..pindex-1]
      
      args = arg_str.split(',')
      return "#{module_name}.#{action_name}(session)" if args.length==0
      
      action = "#{module_name}.#{action_name}(session"
      
      args.each do |arg|
        action << ", " + arg.strip
      end
      action << ')'
      return action
    else
      return  "#{module_name}.#{action_name}(session)"
    end
  end
  
  def initialize(game_module)
    @game_board = GameComponent.new('',self,nil,nil)
    @game_module = game_module
    @execution_queue = []
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
    value
  end
  
  def [] (key)
    return nil unless key
    return nil if key.length == 0
    
    sub_key_list = key.split('.');
    num_sub_keys = sub_key_list.length
    
    component = @game_board
    generation=1

    sub_key_list.each do |sub_key|
      child = component.child(sub_key)

      return component[sub_key] if child==nil && generation==num_sub_keys
      return nil unless child
      
      component=child
      generation+=1
    end
    
    return component
  end
  
  ## create a new stack component
  def create_new_stack(key)
    sub_key_list = key.split('.');
    num_sub_keys = sub_key_list.length
    
    component = @game_board
    generation=1

    sub_key_list.each do |sub_key|
      child = component.child(sub_key)
      if generation==num_sub_keys
        puts "Added stack #{sub_key}"
        component=component.add_child(sub_key, GameComponentStack.new(sub_key, self, component))
      elsif child==nil
        child = component.add_child(sub_key,GameComponent.new(sub_key, self, component,nil))
        component=child
        puts "Added #{sub_key}"
      else
        component=child
      end
      generation+=1
    end
    
    return component
  end
  
  def add_to_component_stack(key, prototype, num_instances)
    component_stack = self[key]
    
    if component_stack == nil
      component_stack = create_new_stack(key)
    end
    
    num_instances.times {component_stack << GameComponent.new(prototype.name, self, component_stack, prototype)}
    
    component_stack
  end
  
  def get_action(action_name)
    # changes this to be module.action_name(session[,optional parameters])
    return GameSession.convert_action(@game_module, action_name)
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